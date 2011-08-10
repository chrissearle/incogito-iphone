//
//  FeedbackAvailability.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "FeedbackAvailability.h"
#import "FlurryAPI.h"
#import "DDXML.h"

@implementation FeedbackAvailability

@synthesize url;
@synthesize dict;

- (void)populateDict {
    [FlurryAPI logEvent:@"Feedback Overview Retrieval" timed:YES];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.url];
	
	[urlRequest setValue:@"incogito-iPhone" forHTTPHeaderField:@"User-Agent"];
	
	NSError *error = nil;
	
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	
	// Perform request and get JSON back as a NSData object
	NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];

	app.networkActivityIndicatorVisible = NO;
	
	[FlurryAPI endTimedEvent:@"Feedback Overview Retrieval" withParameters:nil];

    
    NSMutableDictionary *mutableDictionary = [[[NSMutableDictionary alloc] init] autorelease];    

    if (nil != error) {
		[FlurryAPI logError:@"Error retrieving feedback overview" message:[NSString stringWithFormat:@"Unable to retrieve feedback overview from URL %@", self.url] error:error];
	} else {
        DDXMLDocument *xmlDoc;
        
        NSError *err=nil;
        
        
        xmlDoc = [[[DDXMLDocument alloc] initWithData:response options:DDXMLDocumentXHTMLKind error:&err] autorelease];

        NSArray *nodes = [xmlDoc nodesForXPath:@"//*[(local-name()='a') and (@id)   ]"
                                         error:&err];

        NSLog(@"Found %d feedback URLs", [nodes count]);
        
        for (DDXMLElement *element in nodes) {
            NSString *sessionId = [[element attributeForName:@"id"] stringValue];
            NSString *href = [[element attributeForName:@"href"] stringValue];
            
            NSLog(@"Saw %@ with %@", sessionId, href);
            
            [mutableDictionary setObject:href forKey:sessionId];
        }
    }

    dict = [[[NSDictionary alloc] initWithDictionary:mutableDictionary] autorelease];
}

- (FeedbackAvailability *) initWithUrl:(NSURL *)downloadUrl {
    self = [super init];
    
    self.url = downloadUrl;
	
    [self populateDict];
    
	return self;
}

- (BOOL)isFeedbackAvailableForSession:(NSString *)sessionId {
    NSLog(@"Checking for feedback availability for %@", sessionId);
    
    return [[dict allKeys] containsObject:sessionId];
}

- (NSURL *)feedbackUrlForSession:(NSString *)sessionId {
    if (![self isFeedbackAvailableForSession:sessionId]) {
        return nil;
    }
    
    return [NSURL URLWithString:[dict objectForKey:sessionId]];
}

@end
