//
//  Preferences.h
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Preferences : NSObject {

}

+ (NSString *)getPreferenceAsString:(NSString *) key;
+ (NSArray *)getPreferenceAsArray:(NSString *) key;
+ (NSDate *)getPreferenceAsDate:(NSString *) key;

@end
