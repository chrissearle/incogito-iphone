//
//  SessionDownloader.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SessionDownloader.h"

@implementation SessionDownloader

@synthesize url;

- (SessionDownloader *) initWithUrl:(NSURL *)downloadUrl {
	self = [super init];
	
	self.url = downloadUrl;
	
	return self;
}

- (NSData *)sessionData {
	[FlurryAPI logEvent:@"Retrieving Sessions" timed:YES];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.url];
	
	[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[urlRequest setValue:@"incogito-iPhone" forHTTPHeaderField:@"User-Agent"];
	
	NSError *error = nil;
    NSURLResponse *resp = nil;
	
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	
	// Perform request and get JSON back as a NSData object
	NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&resp error:&error];
	
	app.networkActivityIndicatorVisible = NO;
	
	[FlurryAPI endTimedEvent:@"Retrieving Sessions" withParameters:nil];
	
    if (nil != resp && [resp isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)resp;
        
        if ([httpResp statusCode] >= 400) {
            [FlurryAPI logEvent:@"Unable to retrieve sessions" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                               self.url,
                                                                               @"URL",
                                                                               [httpResp statusCode],
                                                                               @"Status Code",
                                                                               nil]];
            AppLog(@"Download failed with code %d", [httpResp statusCode]);
            
            return nil;
        }
    }
    
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
