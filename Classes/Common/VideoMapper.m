//
//  VideoMapper.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "VideoMapper.h"
#import "JavaZonePrefs.h"
#import "CachedPropertyFile.h"

@implementation VideoMapper

- (NSString *)filePath {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
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
    [CachedPropertyFile retrieveFile:@"video.plist" fromUrl:[NSURL URLWithString:[JavaZonePrefs videoUrl]]];
}

@end
