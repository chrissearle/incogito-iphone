//
//  JavaZonePrefs.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "JavaZonePrefs.h"
#import "Preferences.h"

@implementation JavaZonePrefs

+ (NSString *)feedbackUrl {
    return [Preferences getPreferenceAsString:@"FeedbackUrl"];
}

+ (NSString *)sessionUrl {
    return [Preferences getPreferenceAsString:@"SessionUrl"];
}

+ (NSString *)callForPapersUrl {
    return [Preferences getPreferenceAsString:@"CFPUrl"];
}

+ (NSDate *)callForPapersDate {
    return [Preferences getPreferenceAsDate:@"CFPDate"];
}

+ (NSArray *)clubZonePins {
    return [Preferences getPreferenceAsArray:@"ClubZone"];
}

@end
