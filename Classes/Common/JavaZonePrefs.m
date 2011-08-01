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

+ (NSArray *)activeYears {
    return [Preferences getPreferenceAsArray:@"ActiveYears"];
}

+ (BOOL)showBioPic {
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"showBioPic"];
            
    if (flag == YES) {
        NSLog(@"Retrieved bio pic %@", @"On");
    } else {
        NSLog(@"Retrieved bio pic %@", @"Off");
    }
    
    return flag;
}

+ (void)setShowBioPic:(BOOL) flag {
    if (flag == YES) {
        NSLog(@"Setting bio pic %@", @"On");
    } else {
        NSLog(@"Setting bio pic %@", @"Off");
    }
    
	[[NSUserDefaults standardUserDefaults] setBool:flag forKey:@"showBioPic"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
