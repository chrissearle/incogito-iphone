//
//  SessionParser.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SessionParser.h"
#import "JSON.h"

@implementation SessionParser

@synthesize data;

- (SessionParser *)initWithData:(NSData *)downloadData {
	self = [super init];
	
	self.data = downloadData;
	
	return self;
}

- (NSArray *)sessions {
	[FlurryAPI logEvent:@"JSON Parsing" timed:YES];
	
	// Create new SBJSON parser object
	SBJSON *parser = [[SBJSON alloc] init];
	
	// Get JSON as a NSString from NSData response
	NSString *json_string = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
	
	NSError *error = nil;
	
	// parse the JSON response into an object
	// Here we're using NSArray since we're parsing an array of JSON status objects
	NSDictionary *sessionData = [parser objectWithString:json_string error:&error];
	
	[FlurryAPI endTimedEvent:@"JSON Parsing" withParameters:nil];
	
	[json_string release];
	[parser release];
	
	if (nil != error) {
		[FlurryAPI logError:@"Error parsing sessions" message:@"Unable to parse sessions" error:error];
		return nil;
	}
	
	return [sessionData objectForKey:@"sessions"];
}

- (void)dealloc {
	[data release];
    
	[super dealloc];
}

@end
