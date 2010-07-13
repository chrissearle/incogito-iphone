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

@implementation JavazoneSessionsRetriever

@synthesize managedObjectContext;

- (void)retrieveSessionsWithUrl:(NSString *)urlString {
	// Create new SBJSON parser object
	SBJSON *parser = [[SBJSON alloc] init];
	
	NSMutableURLRequest *urlRequest;
	
	urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	
	[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	// Perform request and get JSON back as a NSData object
	NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	
	// Get JSON as a NSString from NSData response
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	
	// parse the JSON response into an object
	// Here we're using NSArray since we're parsing an array of JSON status objects
	NSDictionary *object = [parser objectWithString:json_string error:nil];
	
	NSArray *array = [object objectForKey:@"sessions"];
	
	[self invalidateSessions];
	
	// Each element in statuses is a single status
	// represented as a NSDictionary
	for (NSDictionary *item in array)
	{
		[self addSession:item];
	}
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

- (void) addSession:(NSDictionary *)item {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(jzId like[cd] %@)", [item objectForKey:@"id"]];
	
	[request setPredicate:predicate];

	NSError *error;

	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	
	JZSession *session;						  
	
	if (array == nil)
	{
		// Create and configure a new instance of the Event entity
		session = (JZSession *)[NSEntityDescription insertNewObjectForEntityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	} else {
		int count = [array count];
		
		if (count == 0) {
			session = (JZSession *)[NSEntityDescription insertNewObjectForEntityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
		} else {
			session = (JZSession *)[array objectAtIndex:0];
		}
	}
	
	[session setTitle:[item objectForKey:@"title"]];
	[session setJzId:[item objectForKey:@"id"]];
	[session setActive:[NSNumber numberWithBool:TRUE]];
	
	NSLog(@"%@ - %@", [session jzId], [session title]);
	
		
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
}

@end
