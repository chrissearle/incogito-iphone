//
//  SessionProperties.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SessionProperties.h"


@implementation SessionProperties

- (NSString *)getSessionUrl {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"incogito" ofType:@"plist"];
	NSDictionary* plistDict = [[[NSDictionary alloc] initWithContentsOfFile:filePath] retain];
	
	NSString *urlString = [plistDict objectForKey:@"SessionUrl"];
	NSLog(@"Session URL %@", urlString);
	[plistDict release];
	
	return urlString;
}	

@end
