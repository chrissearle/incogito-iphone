//
//  VideoMapper.m
//  incogito
//
//  Created by Chris Searle on 14.04.11.
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "VideoMapper.h"


@implementation VideoMapper

+ (NSDictionary *)dictionary {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"plist"];
	return [[[NSDictionary alloc] initWithContentsOfFile:filePath] autorelease];
}

+ (NSString *)streamingUrlForSession:(NSString *) sessionId {
 	NSDictionary* plistDict = [self dictionary];
	
    if (plistDict == nil) {
        return nil;
    }

    return [NSString stringWithString:[plistDict objectForKey:sessionId]];   
}

@end
