//
//  javazoneSessionsRetriever.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "JavazoneSessionsRetriever.h"
#import "JSON.h"
#import "JZSession.h"
#import "JZSessionBio.h"
#import "JZLabel.h"
#import "FlurryAPI.h"

@implementation JavazoneSessionsRetriever

@synthesize managedObjectContext;
@synthesize refreshCommonViewController;
@synthesize labelUrls;
@synthesize levelUrls;

- (NSUInteger)retrieveSessions {
	[FlurryAPI logEvent:@"Session Retrieval" timed:YES];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"incogito" ofType:@"plist"];
	NSDictionary* plistDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
	
	NSString *urlString = [plistDict objectForKey:@"SessionUrl"];
	NSLog(@"Session URL %@", urlString);
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[plistDict release];
	
	[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[urlRequest setValue:@"incogito-iPhone" forHTTPHeaderField:@"User-Agent"];
	
	NSError *error = nil;
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Calling update URL", [[[NSDate alloc] init] autorelease]);
#endif
	
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	
	// Perform request and get JSON back as a NSData object
	NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Called update URL", [[[NSDate alloc] init] autorelease]);
#endif
	
	
	if (nil != error) {
		NSLog(@"%@:%@ Error retrieving sessions: %@", [self class], _cmd, [error localizedDescription]);
		return 0;
	}
	
	app.networkActivityIndicatorVisible = NO;
	
	[FlurryAPI endTimedEvent:@"Session Retrieval" withParameters:nil];
	
	[FlurryAPI logEvent:@"JSON Parsing" timed:YES];

	// Create new SBJSON parser object
	SBJSON *parser = [[SBJSON alloc] init];
	
	// Get JSON as a NSString from NSData response
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	
	error = nil;
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Parsing JSON", [[[NSDate alloc] init] autorelease]);
#endif
	
	// parse the JSON response into an object
	// Here we're using NSArray since we're parsing an array of JSON status objects
	NSDictionary *object = [parser objectWithString:json_string error:&error];
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Parsed JSON", [[[NSDate alloc] init] autorelease]);
#endif
	
	[FlurryAPI endTimedEvent:@"JSON Parsing" withParameters:nil];

	[json_string release];
	[parser release];
	
	if (nil != error) {
		NSLog(@"%@:%@ Error parsing sessions: %@", [self class], _cmd, [error localizedDescription]);
		return 0;
	}
	
	[refreshCommonViewController performSelectorOnMainThread:@selector(showProgressBar:) withObject:nil waitUntilDone:YES];
	

	NSArray *array = [object objectForKey:@"sessions"];
	
	[FlurryAPI logEvent:@"Clearing" timed:YES];

	// Set all sessions inactive. Active flag will be set for existing and new sessions retrieved.
	[self invalidateSessions];
	
	// Remove speakers - they will get added for all active sessions.
	[self removeAllEntitiesByName:@"JZSessionBio"];
	
	// Remove labels - they will get added for all active sessions.
	[self removeAllEntitiesByName:@"JZLabel"];

	
	[FlurryAPI endTimedEvent:@"Clearing" withParameters:nil];

#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Adding sessions", [[[NSDate alloc] init] autorelease]);
#endif
	
	[FlurryAPI logEvent:@"Storing" timed:YES];

	// Each element in statuses is a single status
	// represented as a NSDictionary
	int counter = 0;
	self.labelUrls = [[[NSMutableDictionary alloc] init] retain];
	self.levelUrls = [[[NSMutableDictionary alloc] init] retain];
	
	for (NSDictionary *item in array)
	{
		counter++;
		
		float progress = (1.0 / [array count]) * counter;
		
		[refreshCommonViewController performSelectorOnMainThread:@selector(setProgressTo:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:YES];
		
		[self addSession:item];
	}
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Added sessions", [[[NSDate alloc] init] autorelease]);
#endif
	
	for (NSString *name in self.levelUrls) {
		[self downloadIconFromUrl:[self.levelUrls objectForKey:name] withName:name toPrefix:@"levelIcons"];
	}
	for (NSString *name in self.labelUrls) {
		[self downloadIconFromUrl:[self.labelUrls objectForKey:name] withName:name toPrefix:@"labelIcons"];
	}
	
	
	[self.labelUrls release];
	[self.levelUrls release];
	
	[FlurryAPI endTimedEvent:@"Storing" withParameters:nil];

	return [array count];
}

- (void) invalidateSessions {
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Invalidating sessions", [[[NSDate alloc] init] autorelease]);
#endif
	
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSError *error = nil;
	
	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	
	if (nil != error) {
		NSLog(@"%@:%@ Error fetching sessions: %@", [self class], _cmd, [error localizedDescription]);
		return;
	}
	
	
	for (JZSession *session in array) {
		[session setActive:[NSNumber numberWithBool:FALSE]];
	}
	
	error = nil;
	
	if (![managedObjectContext save:&error]) {
		if (nil != error) {
			NSLog(@"%@:%@ Error saving sessions: %@", [self class], _cmd, [error localizedDescription]);
			return;
		}
	}	
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Invalidated sessions", [[[NSDate alloc] init] autorelease]);
#endif
	

	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *levelPath = [docDir stringByAppendingPathComponent:@"levelIcons"];
	NSString *labelPath = [docDir stringByAppendingPathComponent:@"labelIcons"];
	
	[fileManager removeItemAtPath:levelPath error:NULL];
	[fileManager removeItemAtPath:labelPath error:NULL];

	[fileManager createDirectoryAtPath:levelPath withIntermediateDirectories:YES attributes:nil error:NULL];
	[fileManager createDirectoryAtPath:labelPath withIntermediateDirectories:YES attributes:nil error:NULL];
}

- (void) addSession:(NSDictionary *)item {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(jzId like[cd] %@)", [item objectForKey:@"id"]];
	
	[request setPredicate:predicate];
	
	NSError *error = nil;
	
	NSArray *sessions = [managedObjectContext executeFetchRequest:request error:&error];
	
	if (nil != error) {
		NSLog(@"%@:%@ Error fetching sessions: %@", [self class], _cmd, [error localizedDescription]);
		return;
	}
	
	JZSession *session;
	
	if (sessions == nil)
	{
		// Create and configure a new instance of the Event entity
		session = (JZSession *)[NSEntityDescription insertNewObjectForEntityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	} else {
		int count = [sessions count];
		
		if (count == 0) {
			session = (JZSession *)[NSEntityDescription insertNewObjectForEntityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
		} else {
			session = (JZSession *)[sessions objectAtIndex:0];
		}
	}
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Adding session with title %@", [[[NSDate alloc] init] autorelease], [item objectForKey:@"title"]);
#endif
	
	[session setJzId:[item objectForKey:@"id"]];
	[session setActive:[NSNumber numberWithBool:TRUE]];
	
	[session setTitle:[self getPossibleNilString:@"title" fromDict:item]];
	
	NSString *roomString = [self getPossibleNilString:@"room" fromDict:item];
	
	if (roomString == @"") {
		[session setRoom:0];
	} else {
		[session setRoom:[NSNumber numberWithInt:[[roomString
												   stringByReplacingOccurrencesOfString:@"Sal " withString:@""] intValue]]];
	}
	
	NSDictionary *level = [item objectForKey:@"level"];
	
	[session setLevel:[level objectForKey:@"id"]];
	[levelUrls setObject:[self getPossibleNilString:@"iconUrl" fromDict:level] forKey:[session level]];

	[session setDetail:[self getPossibleNilString:@"bodyHtml" fromDict:item]];
	
	// Dates
	NSObject *start = [item objectForKey:@"start"];
	if ([start class] != [NSNull class]) {
		NSDictionary *start = [item objectForKey:@"start"];
		[session setStartDate:[self getDateFromJson:start]];
	}
	
	NSObject *end = [item objectForKey:@"end"];
	if ([end class] != [NSNull class]) {
		NSDictionary *end = [item objectForKey:@"end"];
		[session setEndDate:[self getDateFromJson:end]];
	}
	
	NSArray *speakers = [item objectForKey:@"speakers"];
	
	for (NSDictionary *speaker in speakers) {
		JZSessionBio *sessionBio = (JZSessionBio *)[NSEntityDescription insertNewObjectForEntityForName:@"JZSessionBio" inManagedObjectContext:managedObjectContext];
		
		[sessionBio setBio:[self getPossibleNilString:@"bioHtml" fromDict:speaker]];
		[sessionBio setName:[self getPossibleNilString:@"name" fromDict:speaker]];
		
		[session addSpeakersObject:sessionBio];
	}
	
	NSArray *labels = [item objectForKey:@"labels"];
	
	for (NSDictionary *label in labels) {
		JZLabel *lbl = (JZLabel *)[NSEntityDescription insertNewObjectForEntityForName:@"JZLabel" inManagedObjectContext:managedObjectContext];
		
		[lbl setJzId:[label objectForKey:@"id"]];
		
		[lbl setTitle:[self getPossibleNilString:@"displayName" fromDict:label]];
		
		[labelUrls setObject:[self getPossibleNilString:@"iconUrl" fromDict:label] forKey:[lbl jzId]];
		
		[session addLabelsObject:lbl];
	}
	
#ifdef USE_DUMMY_LABELS
	
	if ([speakers count] % 2 == 0) {
		JZLabel *lbl = (JZLabel *)[NSEntityDescription insertNewObjectForEntityForName:@"JZLabel" inManagedObjectContext:managedObjectContext];
		
		[lbl setJzId:@"enterprise"];
		[lbl setTitle:@"Enterprise"];
		
		[session addLabelsObject:lbl];
	} else {
		JZLabel *lbl = (JZLabel *)[NSEntityDescription insertNewObjectForEntityForName:@"JZLabel" inManagedObjectContext:managedObjectContext];
		
		[lbl setJzId:@"core-jvm"];
		[lbl setTitle:@"Core/JVM"];
		
		[session addLabelsObject:lbl];
	}
	
	if ([[item objectForKey:@"title"] hasPrefix:@"H"]) {
		JZLabel *lbl = (JZLabel *)[NSEntityDescription insertNewObjectForEntityForName:@"JZLabel" inManagedObjectContext:managedObjectContext];
		
		[lbl setJzId:@"tooling"];
		[lbl setTitle:@"Tooling"];
		
		[session addLabelsObject:lbl];
	}
	
#endif
	
	error = nil;
	
	if (![managedObjectContext save:&error]) {
		if (nil != error) {
			NSLog(@"%@:%@ Error saving sessions: %@", [self class], _cmd, [error localizedDescription]);
			return;
		}
	}
}

- (NSDate *)getDateFromJson:(NSDictionary *)jsonDate {
	NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00 +0200",
							[jsonDate objectForKey:@"year"],
							[jsonDate objectForKey:@"month"],
							[jsonDate objectForKey:@"day"],
							[jsonDate objectForKey:@"hour"],
							[jsonDate objectForKey:@"minute"]];
	
	NSDate *date = [[[NSDate alloc] initWithString:dateString] autorelease];
	
	return date;
}

- (void) removeAllEntitiesByName:(NSString *)entityName {
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Removing all %@", [[[NSDate alloc] init] autorelease], entityName);
#endif
	
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:entityName inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSError *error = nil;
	
	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	
	for (NSManagedObject *item in array) {
		[managedObjectContext deleteObject:item];
	}
	
	if (![managedObjectContext save:&error]) {
		if (nil != error) {
			NSLog(@"%@:%@ Error saving sessions: %@", [self class], _cmd, [error localizedDescription]);
			return;
		}
	}	
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Removed all %@", [[[NSDate alloc] init] autorelease], entityName);
#endif
}

- (NSString *)getPossibleNilString:(NSString *)key fromDict:(NSDictionary *)dict {
	NSString *value = [dict objectForKey:key];
	
	if ([value isKindOfClass:[NSNull class]]) {
		NSString *id = [dict objectForKey:@"id"];
		
		if ([id isKindOfClass:[NSNull class]]) {
			NSLog(@"No %@ found for unknown object", key);
		} else {
			NSLog(@"No %@ found for %@", key, id);
		}
		
		return @"";
	}
	
	return value;
}

- (void)downloadIconFromUrl:(NSString *)url withName:(NSString *)name toPrefix:(NSString *)prefix {
	UIApplication* app = [UIApplication sharedApplication];

	NSLog(@"Download %@ from %@ to %@", name, url, prefix);

	app.networkActivityIndicatorVisible = YES;
	UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
	app.networkActivityIndicatorVisible = NO;
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:prefix],name];
	NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
	[data1 writeToFile:pngFilePath atomically:YES];
	
	[image release];
}



@end
