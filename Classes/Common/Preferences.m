//
//  Preferences.m
//  incogito
//
//  Created by Chris Searle on 15.02.11.
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "Preferences.h"


@implementation Preferences

+ (NSDictionary *)dictionary {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"incogito" ofType:@"plist"];
	return [[[NSDictionary alloc] initWithContentsOfFile:filePath] autorelease];
}

+ (NSString *)getPreferenceAsString:(NSString *) key {
	NSDictionary* plistDict = [Preferences dictionary];
	
	return [NSString stringWithString:[plistDict objectForKey:key]];
}

+ (NSArray *)getPreferenceAsArray:(NSString *) key {
	NSDictionary* plistDict = [Preferences dictionary];

	return [[[plistDict objectForKey:key] copy] autorelease];
}

+ (NSDate *)getPreferenceAsDate:(NSString *) key {
	NSDictionary* plistDict = [Preferences dictionary];
	
	return [[[plistDict objectForKey:key] copy] autorelease];
}

@end
