//
//  javazoneSessionsRetriever.m
//  incogito
//
//  Created by Chris Searle on 12.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "JavazoneSessionsRetriever.h"
#import "JSON.h"
#import "JZSession.h"
#import "JZSessionBio.h"

@implementation JavazoneSessionsRetriever

@synthesize managedObjectContext;

- (NSUInteger)retrieveSessionsWithUrl:(NSString *)urlString {
	NSMutableURLRequest *urlRequest;
	
	urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	
	[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	NSError *error = nil;
	
	// Perform request and get JSON back as a NSData object
	NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
	
	if (nil != error) {
		NSLog(@"%@:%s Error retrieving sessions: %@", [self class], _cmd, [error localizedDescription]);
		return 0;
	}
	
	// Create new SBJSON parser object
	SBJSON *parser = [[SBJSON alloc] init];

	// Get JSON as a NSString from NSData response
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		
	// parse the JSON response into an object
	// Here we're using NSArray since we're parsing an array of JSON status objects
	NSDictionary *object = [parser objectWithString:json_string error:nil];
	
	[json_string release];
	[parser release];
	
	NSArray *array = [object objectForKey:@"sessions"];
	
	// Set all sessions inactive. Active flag will be set for existing and new sessions retrieved.
	[self invalidateSessions];
	
	// Remove speakers - they will get added for all active sessions.
	[self removeSpeakers];
	
	// Each element in statuses is a single status
	// represented as a NSDictionary
	for (NSDictionary *item in array)
	{
		[self addSession:item];
	}
	
	return [array count];
}

- (void) invalidateSessions {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];

	NSError *error;

	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	
	for (JZSession *session in array) {
		[session setActive:[NSNumber numberWithBool:FALSE]];
	}
	
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}	
}

- (void) removeSpeakers {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSessionBio" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSError *error;
	
	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	
	for (NSManagedObject *speaker in array) {
		[managedObjectContext deleteObject:speaker];
	}
	
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}	
}

- (void) addSession:(NSDictionary *)item {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(jzId like[cd] %@)", [item objectForKey:@"id"]];
	
	[request setPredicate:predicate];

	NSError *error;

	NSArray *sessions = [managedObjectContext executeFetchRequest:request error:&error];
	
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
	
	[session setTitle:[item objectForKey:@"title"]];
	[session setJzId:[item objectForKey:@"id"]];
	[session setActive:[NSNumber numberWithBool:TRUE]];
	
	[session setRoom:[NSNumber numberWithInt:[[[item objectForKey:@"room"]
											   stringByReplacingOccurrencesOfString:@"Sal " withString:@""] intValue]]];
	
	[session setLevel:[[item objectForKey:@"level"] objectForKey:@"id"]];
	
	// Dates
	NSDictionary *start = [item objectForKey:@"start"];
	NSDictionary *end = [item objectForKey:@"end"];
	
	[session setStartDate:[self getDateFromJson:start]];
	[session setEndDate:[self getDateFromJson:end]];
		
	NSLog(@"%@ - %@", [session jzId], [session title]);

	NSArray *speakers = [item objectForKey:@"speakers"];
	
	for (NSDictionary *speaker in speakers) {
		JZSessionBio *sessionBio = (JZSessionBio *)[NSEntityDescription insertNewObjectForEntityForName:@"JZSessionBio" inManagedObjectContext:managedObjectContext];

		[sessionBio setBio:[speaker objectForKey:@"bioHtml"]];
		[sessionBio setName:[speaker objectForKey:@"name"]];
		
		[session addSpeakersObject:sessionBio];
	}
	
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
}

- (NSDate *)getDateFromJson:(NSDictionary *)jsonDate {
	NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00 +0100",
							[jsonDate objectForKey:@"year"],
							[jsonDate objectForKey:@"month"],
							[jsonDate objectForKey:@"day"],
							[jsonDate objectForKey:@"hour"],
							[jsonDate objectForKey:@"minute"]];

	NSDate *date = [[NSDate alloc] initWithString:dateString];
	
	return date;
}

@end
