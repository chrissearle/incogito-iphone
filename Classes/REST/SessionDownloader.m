//
//  SessionDownloader.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SessionDownloader.h"
#import "FlurryAPI.h"

@implementation SessionDownloader

@synthesize url;

- (SessionDownloader *) initWithUrl:(NSURL *)downloadUrl {
	self = [super init];
	
	self.url = downloadUrl;
	
	return self;
}

- (NSData *)sessionData {
	[FlurryAPI logEvent:@"Session Retrieval" timed:YES];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.url];
	
	[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[urlRequest setValue:@"incogito-iPhone" forHTTPHeaderField:@"User-Agent"];
	
	NSError *error = nil;
	
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	
	// Perform request and get JSON back as a NSData object
	NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
	
	app.networkActivityIndicatorVisible = NO;
	
	[FlurryAPI endTimedEvent:@"Session Retrieval" withParameters:nil];
	
	if (nil != error) {
		[FlurryAPI logError:@"Error retrieving sessions" message:[NSString stringWithFormat:@"Unable to retrieve sessions from URL %@", self.url] error:error];
		return nil;
	}
	
	return response;
}	

- (void)dealloc {
	[url release];
	[super dealloc];
}

@end
