//
//  VideoMapper.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "VideoMapper.h"
#import "JavaZonePrefs.h"

@implementation VideoMapper

- (NSString *)filePath {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/video.plist",docDir];

    return filePath;
}

- (NSDictionary *)dictionary {
	return [[[NSDictionary alloc] initWithContentsOfFile:[self filePath]] autorelease];
}

- (NSString *)streamingUrlForSession:(NSString *) sessionId {
 	NSDictionary* plistDict = [self dictionary];
	
    if (plistDict == nil) {
        return nil;
    }

    NSString *url = [plistDict objectForKey:sessionId];
    
    if (url == nil) {
        return nil;
    }
    
    return [NSString stringWithString:url];
}

- (void)download {
    [FlurryAPI logEvent:@"Video list retrieval" timed:YES];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[JavaZonePrefs videoUrl]]];
	
	[urlRequest setValue:@"incogito-iPhone" forHTTPHeaderField:@"User-Agent"];
	
	NSError *error = nil;
    
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	
	NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    
	app.networkActivityIndicatorVisible = NO;
	
	[FlurryAPI endTimedEvent:@"Video list retrieval" withParameters:nil];
    
    if (nil != error) {
		[FlurryAPI logError:@"Error retrieving video list" message:[NSString stringWithFormat:@"Unable to retrieve video list from URL %@", [JavaZonePrefs videoUrl]] error:error];
        
        return;
    }

    if (response != nil) {
        [response writeToFile:[self filePath] atomically:YES];
    }
}

@end
