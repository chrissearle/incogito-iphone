//
//  JavaZonePrefs.h
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JavaZonePrefs : NSObject

+ (NSString *)feedbackUrl;
+ (NSString *)sessionUrl;
+ (NSString *)videoUrl;

+ (NSString *)callForPapersUrl;
+ (NSDate *)callForPapersDate;

+ (NSArray *)activeYears;

+ (NSString *)registeredEmail;
+ (void)setRegisteredEmail:(NSString *)email;

+ (BOOL)showBioPic;
+ (void)setShowBioPic:(BOOL) flag;

+ (NSDate *)lastSuccessfulUpdate;
+ (void)setLastSuccessfulUpdate:(NSDate *)date;

@end
