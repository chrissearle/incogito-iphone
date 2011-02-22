//
//  SessionProperties.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SessionProperties.h"
#import "Preferences.h"

@implementation SessionProperties

- (NSString *)getSessionUrl {
	NSString *urlString = [Preferences getPreferenceAsString:@"SessionUrl"];

	NSLog(@"Session URL %@", urlString);
	
	return urlString;
}	

@end
