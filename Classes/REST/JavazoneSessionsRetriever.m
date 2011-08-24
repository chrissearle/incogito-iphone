//
//  javazoneSessionsRetriever.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "JavazoneSessionsRetriever.h"
#import "SessionDownloader.h"
#import "SessionParser.h"
#import "JavaZonePrefs.h"
#import "SessionDateConverter.h"

#import "JZSession.h"
#import "JZSessionBio.h"
#import "JZLabel.h"

#import "VideoMapper.h"

#import <unistd.h>

@implementation JavazoneSessionsRetriever

@synthesize managedObjectContext;
@synthesize urlString;

@synthesize HUD;
@synthesize labelUrls;
@synthesize levelUrls;
@synthesize bioPics;

@synthesize levelsPath;
@synthesize labelsPath;
@synthesize bioPath;

-(id) init {
    self = [super init];

	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	self.levelsPath = [docDir stringByAppendingPathComponent:@"levelIcons"];
	self.labelsPath = [docDir stringByAppendingPathComponent:@"labelIcons"];
    self.bioPath    = [docDir stringByAppendingPathComponent:@"bioIcons"];


	self.labelUrls = [[[NSMutableDictionary alloc] init] autorelease];
	self.levelUrls = [[[NSMutableDictionary alloc] init] autorelease];
	self.bioPics   = [[[NSMutableDictionary alloc] init] autorelease];
	
	return self;
}

-(void)clearPath:(NSString *)path {
	NSFileManager *fileManager = [NSFileManager defaultManager];

	NSError *error = nil;

	if ([fileManager fileExistsAtPath:path]) {
		[fileManager removeItemAtPath:path error:&error];
		if (nil != error) {
			[FlurryAnalytics logError:@"Error removing path" message:[NSString stringWithFormat:@"Unable to remove items at path %@", path] error:error];
			return;
		}
	}
	
	[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
	if (nil != error) {
		[FlurryAnalytics logError:@"Error creating path" message:[NSString stringWithFormat:@"Unable to create path %@", path] error:error];
		return;
	}
}

- (void)clearData {
	[FlurryAnalytics logEvent:@"Clearing" timed:YES];
	
	// Set all sessions inactive. Active flag will be set for existing and new sessions retrieved.
	[self invalidateSessions];
	
	// Remove any downloaded icons
	[self clearPath:self.levelsPath];
	[self clearPath:self.labelsPath];
    [self clearPath:self.bioPath];
	
	// Remove speakers - they will get added for all active sessions.
	[self removeAllEntitiesByName:@"JZSessionBio"];
	
	// Remove labels - they will get added for all active sessions.
	[self removeAllEntitiesByName:@"JZLabel"];
	
	
	[FlurryAnalytics endTimedEvent:@"Clearing" withParameters:nil];
}

- (NSUInteger)retrieveSessions:(id)sender {
	self.HUD.labelText = @"Downloading";

	// Download
	SessionDownloader *downloader = [[[SessionDownloader alloc] initWithUrl:[NSURL URLWithString:self.urlString]] autorelease];
	
	NSData *responseData = [downloader sessionData];
	
	if (responseData == nil) {
		return 0;
	}
	
	// Parse
	SessionParser *parser = [[[SessionParser alloc] initWithData:responseData] autorelease];
	
	NSArray *sessions = [parser sessions];

	if (sessions == nil) {
		return 0;
	}
	
    [JavaZonePrefs setLastSuccessfulUpdate:[NSDate date]];
    
	// Cleanup
	[self clearData];

	// Store
	[FlurryAnalytics logEvent:@"Storing" timed:YES];

	self.HUD.mode = MBProgressHUDModeDeterminate;
	self.HUD.labelText = @"Storing";
	
	int counter = 0;
	
	for (NSDictionary *session in sessions)
	{
		counter++;
		
		float progress = (1.0 / [sessions count]) * counter;
		
		self.HUD.progress = progress;

		[self addSession:session];
	}
    
	[FlurryAnalytics endTimedEvent:@"Storing" withParameters:nil];

    if ([JavaZonePrefs showBioPic]) {
        [FlurryAnalytics logEvent:@"Storing biopics" timed:YES];

        self.HUD.mode = MBProgressHUDModeDeterminate;
        self.HUD.labelText = @"Retrieving photos";

        int picCounter = 0;
        
        for (NSString *name in self.bioPics) {
            picCounter++;
            
            float progress = (1.0 / [self.bioPics count]) * picCounter;
            
            self.HUD.progress = progress;

            [self getJsonImage:[self.bioPics objectForKey:name] toFile:name inPath:self.bioPath];
        }

    	[FlurryAnalytics endTimedEvent:@"Storing biopics" withParameters:nil];
    }
    
	self.HUD.mode = MBProgressHUDModeIndeterminate;
	self.HUD.labelText = @"Retrieving icons";

    [FlurryAnalytics logEvent:@"Storing icons" timed:YES];

	for (NSString *name in self.levelUrls) {
		[self downloadIconFromUrl:[self.levelUrls objectForKey:name] withName:name toFolder:self.levelsPath];
	}
	for (NSString *name in self.labelUrls) {
		[self downloadIconFromUrl:[self.labelUrls objectForKey:name] withName:name toFolder:self.labelsPath];
	}

    [FlurryAnalytics endTimedEvent:@"Storing icons" withParameters:nil];
	
	self.HUD.labelText = @"Checking for videos";

    [FlurryAnalytics logEvent:@"Storing video" timed:YES];

    VideoMapper *mapper = [[[VideoMapper alloc] init] autorelease];
    [mapper download];
    [FlurryAnalytics endTimedEvent:@"Storing video" withParameters:nil];

	self.HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"117-Todo.png"]] autorelease];
	self.HUD.mode = MBProgressHUDModeCustomView;
	self.HUD.labelText = @"Complete";
	self.HUD.detailsLabelText = [NSString stringWithFormat:@"%d sessions available.", [sessions count]];
	sleep(2);
	
	return [sessions count];
}

- (void) invalidateSessions {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:self.managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSError *error = nil;
	
	NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
	
	if (nil != error) {
		[FlurryAnalytics logError:@"Error fetching sessions" message:@"Unable to fetch sessions for invalidation" error:error];
		return;
	}
	
	
	for (JZSession *session in array) {
		[session setActive:[NSNumber numberWithBool:FALSE]];
	}
	
	error = nil;
	
	if (![self.managedObjectContext save:&error]) {
		if (nil != error) {
			[FlurryAnalytics logError:@"Error fetching sessions" message:@"Unable to persist sessions after invalidation" error:error];
			AppLog(@"%@:%@ Error saving sessions: %@", [self class], _cmd, [error localizedDescription]);
			return;
		}
	}	
}

- (void) addSession:(NSDictionary *)item {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:self.managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(jzId like[cd] %@)", [item objectForKey:@"id"]];
	
	[request setPredicate:predicate];
	
	NSError *error = nil;
	
	NSArray *sessions = [self.managedObjectContext executeFetchRequest:request error:&error];
	
	if (nil != error) {
		AppLog(@"%@:%@ Error fetching sessions: %@", [self class], _cmd, [error localizedDescription]);
		return;
	}
	
	JZSession *session;
	
	if (sessions == nil)
	{
		// Create and configure a new instance of the Event entity
		session = (JZSession *)[NSEntityDescription insertNewObjectForEntityForName:@"JZSession" inManagedObjectContext:self.managedObjectContext];
	} else {
		int count = [sessions count];
		
		if (count == 0) {
			session = (JZSession *)[NSEntityDescription insertNewObjectForEntityForName:@"JZSession" inManagedObjectContext:self.managedObjectContext];
		} else {
			session = (JZSession *)[sessions objectAtIndex:0];
		}
	}
	
	AppLog(@"%@ Adding session with title %@", [[[NSDate alloc] init] autorelease], [item objectForKey:@"title"]);
	
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
		JZSessionBio *sessionBio = (JZSessionBio *)[NSEntityDescription insertNewObjectForEntityForName:@"JZSessionBio" inManagedObjectContext:self.managedObjectContext];
		
		[sessionBio setBio:[self getPossibleNilString:@"bioHtml" fromDict:speaker]];
		[sessionBio setName:[self getPossibleNilString:@"name" fromDict:speaker]];
		
		[session addSpeakersObject:sessionBio];
		
        if ([JavaZonePrefs showBioPic]) {
            NSString *speakerPic = [self getPossibleNilString:@"photoUrl" fromDict:speaker];
		
            if (speakerPic != nil) {
                [bioPics setObject:speakerPic forKey:[sessionBio name]];
            }
        }
	}
	
	NSArray *labels = [item objectForKey:@"labels"];
	
	for (NSDictionary *label in labels) {
		JZLabel *lbl = (JZLabel *)[NSEntityDescription insertNewObjectForEntityForName:@"JZLabel" inManagedObjectContext:self.managedObjectContext];
		
		[lbl setJzId:[label objectForKey:@"id"]];
		
		[lbl setTitle:[self getPossibleNilString:@"displayName" fromDict:label]];
		
		[labelUrls setObject:[self getPossibleNilString:@"iconUrl" fromDict:label] forKey:[lbl jzId]];
		
		[session addLabelsObject:lbl];
	}
	
#ifdef USE_DUMMY_LABELS
	
	if ([speakers count] % 2 == 0) {
		JZLabel *lbl = (JZLabel *)[NSEntityDescription insertNewObjectForEntityForName:@"JZLabel" inManagedObjectContext:self.managedObjectContext];
		
		[lbl setJzId:@"enterprise"];
		[lbl setTitle:@"Enterprise"];
		
		[session addLabelsObject:lbl];
	} else {
		JZLabel *lbl = (JZLabel *)[NSEntityDescription insertNewObjectForEntityForName:@"JZLabel" inManagedObjectContext:self.managedObjectContext];
		
		[lbl setJzId:@"core-jvm"];
		[lbl setTitle:@"Core/JVM"];
		
		[session addLabelsObject:lbl];
	}
	
	if ([[item objectForKey:@"title"] hasPrefix:@"H"]) {
		JZLabel *lbl = (JZLabel *)[NSEntityDescription insertNewObjectForEntityForName:@"JZLabel" inManagedObjectContext:self.managedObjectContext];
		
		[lbl setJzId:@"tooling"];
		[lbl setTitle:@"Tooling"];
		
		[session addLabelsObject:lbl];
	}
	
#endif
	
	error = nil;
	
	if (![self.managedObjectContext save:&error]) {
		if (nil != error) {
			AppLog(@"%@:%@ Error saving sessions: %@", [self class], _cmd, [error localizedDescription]);
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
	
    return [SessionDateConverter dateFromString:dateString];
}

- (void) removeAllEntitiesByName:(NSString *)entityName {
	AppLog(@"%@ Removing all %@", [[[NSDate alloc] init] autorelease], entityName);
	
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSError *error = nil;
	
	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	
	for (NSManagedObject *item in array) {
		[self.managedObjectContext deleteObject:item];
	}
	
	if (![self.managedObjectContext save:&error]) {
		if (nil != error) {
			AppLog(@"%@:%@ Error saving sessions: %@", [self class], _cmd, [error localizedDescription]);
			return;
		}
	}	
	
	AppLog(@"%@ Removed all %@", [[[NSDate alloc] init] autorelease], entityName);
}

- (NSString *)getPossibleNilString:(NSString *)key fromDict:(NSDictionary *)dict {
	NSString *value = [dict objectForKey:key];
	
	if ([value isKindOfClass:[NSNull class]]) {
		NSString *id = [dict objectForKey:@"id"];
		
		if ([id isKindOfClass:[NSNull class]]) {
			AppLog(@"No %@ found for unknown object", key);
		} else {
			AppLog(@"No %@ found for %@", key, id);
		}
		
		return @"";
	}
	
	return value;
}

- (void)downloadIconFromUrl:(NSString *)url withName:(NSString *)name toFolder:(NSString *)folder {
	UIApplication* app = [UIApplication sharedApplication];

	AppLog(@"Download %@ from %@ to %@", name, url, folder);

	app.networkActivityIndicatorVisible = YES;
	UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
	app.networkActivityIndicatorVisible = NO;
	
	NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",folder,name];
	NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
	[data1 writeToFile:pngFilePath atomically:YES];
	
	[image release];
}

- (void)getJsonImage:(NSString *)imageUrl toFile:(NSString *)file inPath:(NSString *)path {
	AppLog(@"Fetching pic %@ to %@ in %@", imageUrl, file, path);

	UIApplication* app = [UIApplication sharedApplication];
	
	app.networkActivityIndicatorVisible = YES;
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
	
	[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[urlRequest setValue:@"incogito-iPhone" forHTTPHeaderField:@"User-Agent"];
	
	NSError *error = nil;
	
	NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];

	app.networkActivityIndicatorVisible = NO;

	if (nil != error) {
		AppLog(@"%@:%@ Error retrieving image: %@", [self class], _cmd, [error localizedDescription]);
		return;
	}	
	
	if ([response length] > 0) {
		UIImage *image = [UIImage imageWithData:response];
	
		NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",path,file];
		AppLog(@"Got data for %@  %.0f x %.0f", pngFilePath, image.size.height, image.size.width);
	
		[[NSData dataWithData:UIImagePNGRepresentation(image)] writeToFile:pngFilePath atomically:YES];
	}
}

- (void)dealloc {
    [managedObjectContext release];
    [urlString release];
    [HUD release];
    [labelUrls release];
    [levelUrls release];
    [bioPics release];
    [levelsPath release];
    [labelsPath release];
    [bioPath release];

    [super dealloc];
}
@end
