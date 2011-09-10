//
//  CachedPropertyDownloader.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "CachedPropertyFile.h"


@implementation CachedPropertyFile

+ (void)retrieveFile:(NSString *) filename fromUrl:(NSURL *)url {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *dataFilePath = [NSString stringWithFormat:@"%@/%@",docDir,filename];
    
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
            return;
        }
    }
    
    [FlurryAnalytics logEvent:@"Retrieving file" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 url,
                                                                 @"URL",
                                                                 nil] timed:YES];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
	
	[urlRequest setValue:@"incogito-iPhone" forHTTPHeaderField:@"User-Agent"];
	
	NSError *error = nil;
	NSURLResponse *resp = nil;
    
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	
	// Perform request and get JSON back as a NSData object
	NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&resp error:&error];
    
	app.networkActivityIndicatorVisible = NO;
	
	[FlurryAnalytics endTimedEvent:@"Retrieving file" withParameters:nil];
    
    if (nil != resp && [resp isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)resp;
        
        if ([httpResp statusCode] >= 400) {
            [FlurryAnalytics logEvent:@"Unable to retrieve file" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                              url,
                                                                                              @"URL",
                                                                                              [NSNumber numberWithInteger:[httpResp statusCode]],
                                                                                              @"Status Code",
                                                                                              nil]];
            AppLog(@"Download failed with code %d", [httpResp statusCode]);
            
            return;
        }
    }
    
    if (nil != error) {
		[FlurryAnalytics logError:@"Error retrieving file" message:[NSString stringWithFormat:@"Unable to retrieve file from URL %@", url] error:error];
        
        return;
    }
    
    [response writeToFile:dataFilePath atomically:YES];
    
    return;
}

+ (NSData *)readFile:(NSString *)filename {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *dataFilePath = [NSString stringWithFormat:@"%@/%@",docDir,filename];
    
    return [NSData dataWithContentsOfFile:dataFilePath];
}

@end
