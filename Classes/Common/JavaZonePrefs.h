//
//  JavaZonePrefs.h
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JavaZonePrefs : NSObject {
}

+ (NSString *)feedbackUrl;
+ (NSString *)sessionUrl;

+ (NSString *)callForPapersUrl;
+ (NSDate *)callForPapersDate;

+ (NSArray *)clubZonePins;

@end
