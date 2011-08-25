//
//  FeedbackAvailability.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "FeedbackAvailability.h"
#import "DDXML.h"

@implementation FeedbackAvailability

@synthesize url;
@synthesize dict;
@synthesize HUD;

- (NSData *)downloadData {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *dataFilePath = [NSString stringWithFormat:@"%@/feedback.xhtml",docDir];

    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *fileError = nil;
    
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:dataFilePath error:&fileError];

    if (fileError != nil) {
        AppLog(@"Got file error reading file attributes for file %@", dataFilePath);
    }
    
	if (fileAttributes != nil && fileError == nil) {
        NSTimeInterval interval = [[fileAttributes fileModificationDate] timeIntervalSinceNow];
        
        AppLog(@"Time interval %f", interval);
        
        if (interval > -3600) {
            return [NSData dataWithContentsOfFile:dataFilePath];
        }
    }
                                    
                                    
    [FlurryAnalytics logEvent:@"Feedback Overview Retrieval" timed:YES];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.url];
	
	[urlRequest setValue:@"incogito-iPhone" forHTTPHeaderField:@"User-Agent"];
	
	NSError *error = nil;
	NSURLResponse *resp = nil;
    
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	
	// Perform request and get JSON back as a NSData object
	NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&resp error:&error];
    
	app.networkActivityIndicatorVisible = NO;
	
	[FlurryAnalytics endTimedEvent:@"Feedback Overview Retrieval" withParameters:nil];

    if (nil != resp && [resp isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)resp;
        
        if ([httpResp statusCode] >= 400) {
            [FlurryAnalytics logEvent:@"Unable to retrieve feedback overview" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                        self.url,
                                                                                        @"URL",
                                                                                        [NSNumber numberWithInteger:[httpResp statusCode]],
                                                                                        @"Status Code",
                                                                                        nil]];
            AppLog(@"Download failed with code %d", [httpResp statusCode]);
            
            return nil;
        }
    }

    
    if (nil != error) {
		[FlurryAnalytics logError:@"Error retrieving feedback overview" message:[NSString stringWithFormat:@"Unable to retrieve feedback overview from URL %@", self.url] error:error];
        
        return nil;
    }

    [response writeToFile:dataFilePath atomically:YES];

    return response;
}

- (void)populateDict:(id)sender {
    NSData *contents = [self downloadData];
    
    NSMutableDictionary *mutableDictionary = [[[NSMutableDictionary alloc] init] autorelease];    

    if (contents != nil) {
        DDXMLDocument *xmlDoc;
        
        NSError *err=nil;
        
        
        xmlDoc = [[[DDXMLDocument alloc] initWithData:contents options:DDXMLDocumentXHTMLKind error:&err] autorelease];

        // libXml puts everything in the default namespace in a namespace without prefix. We can't register a fake namespace since KissXML doesn't support that - so we have to use local-name()
        NSArray *nodes = [xmlDoc nodesForXPath:@"//*[(local-name()='a') and (@id)]"
                                         error:&err];

        AppLog(@"Found %d feedback URLs", [nodes count]);
        
        for (DDXMLElement *element in nodes) {
            NSString *sessionId = [[element attributeForName:@"id"] stringValue];
            NSString *href = [[element attributeForName:@"href"] stringValue];
            
            AppLog(@"Saw %@ with %@", sessionId, href);
            
            [mutableDictionary setObject:href forKey:sessionId];
        }
    }

    self.dict = [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

- (FeedbackAvailability *) initWithUrl:(NSURL *)downloadUrl {
    self = [super init];
    
    if (self) {
        url = [downloadUrl copy];
    }
	
	return self;
}

- (BOOL)isFeedbackAvailableForSession:(NSString *)sessionId {
    AppLog(@"Checking for feedback availability for %@", sessionId);
    
    return [[self.dict allKeys] containsObject:sessionId];
}

- (NSURL *)feedbackUrlForSession:(NSString *)sessionId {
    if (![self isFeedbackAvailableForSession:sessionId]) {
        return nil;
    }
    
    return [NSURL URLWithString:[self.dict objectForKey:sessionId]];
}

- (void)dealloc {
    [url release];
    [dict release];
    [HUD release];
    
    [super dealloc];
}

@end
