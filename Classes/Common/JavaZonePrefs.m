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

+ (NSString *)videoUrl {
    return [Preferences getPreferenceAsString:@"VideoUrl"];
}

+ (NSString *)callForPapersUrl {
    return [Preferences getPreferenceAsString:@"CFPUrl"];
}

+ (NSDate *)callForPapersDate {
    return [Preferences getPreferenceAsDate:@"CFPDate"];
}

+ (NSArray *)activeYears {
    return [Preferences getPreferenceAsArray:@"ActiveYears"];
}

// UserDefault Prefs

+ (void)setObject:(NSObject *)value forKey:(NSString *)key {
    AppLog(@"Setting %@ for key %@", value, key);
    
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getStringForKey:(NSString *)key withDefault:(NSString *)defaultValue {
    NSString *value = defaultValue;
	
	if (nil != [[NSUserDefaults standardUserDefaults] stringForKey:key]) {
		value = [[NSUserDefaults standardUserDefaults] stringForKey:key];
		
		AppLog(@"Retrieved %@ for key %@", value, key);
	}
    
	return value;
}

+ (NSString *)registeredEmail {
    return [self getStringForKey:@"RegisteredEmail" withDefault:nil];
}

+ (void)setRegisteredEmail:(NSString *)email {
    [self setObject:email forKey:@"RegisteredEmail"];
}

+ (BOOL)showBioPic {
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"showBioPic"];
            
    if (flag == YES) {
        AppLog(@"Retrieved bio pic %@", @"On");
    } else {
        AppLog(@"Retrieved bio pic %@", @"Off");
    }
    
    return flag;
}

+ (void)setShowBioPic:(BOOL) flag {
    if (flag == YES) {
        AppLog(@"Setting bio pic %@", @"On");
    } else {
        AppLog(@"Setting bio pic %@", @"Off");
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
    [self setObject:date forKey:@"lastSuccessfulUpdate"];
}

+ (void)setLabelFilter:(NSString *)labelFilter {
    [self setObject:labelFilter forKey:@"labelFilter"];
}

+ (NSString *)labelFilter {
    return [self getStringForKey:@"labelFilter" withDefault:@"All"];
}

+ (NSString *)listFilter {
    return [self getStringForKey:@"listFilter" withDefault:@"All"];
}

+ (void)setListFilter:(NSString *)listFilter {
    [self setObject:listFilter forKey:@"listFilter"];
}

+ (NSString *)levelFilter {
    return [self getStringForKey:@"levelFilter" withDefault:@"All"];
}

+ (void)setLevelFilter:(NSString *)levelFilter {
    [self setObject:levelFilter forKey:@"levelFilter"];
}



@end
