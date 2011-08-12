//
//  JavaZonePrefs.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "JavaZonePrefs.h"
#import "Preferences.h"

@implementation JavaZonePrefs

// JavaZone Prefs

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

// UserDefault Prefs

+ (NSString *)registeredEmail {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"RegisteredEmail"];
}

+ (void)setRegisteredEmail:(NSString *)email {
    NSLog(@"Setting registered e-mail %@", email);
    
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"RegisteredEmail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

+ (NSDate *)lastSuccessfulUpdate {
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSuccessfulUpdate"];

    if (date == nil) {
        [JavaZonePrefs setLastSuccessfulUpdate:[NSDate date]];
    
        date = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSuccessfulUpdate"];
    }
    
    return date;
}

+ (void)setLastSuccessfulUpdate:(NSDate *)date {
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"lastSuccessfulUpdate"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
