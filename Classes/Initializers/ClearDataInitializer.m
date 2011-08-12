//
//  ClearDataInitializer.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "ClearDataInitializer.h"
#import "JavaZonePrefs.h"
#import "JZSession.h"
#import "Section.h"

@implementation ClearDataInitializer

@synthesize activeYears;
@synthesize handler;

- (id)initWithSectionSessionHandler:(SectionSessionHandler *) ssHandler {
    self = [super init];

    [self setActiveYears:[JavaZonePrefs activeYears]];
    [self setHandler:ssHandler];
    
    return self;
}

- (int) getYear:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit;
    NSDateComponents *comp = [calendar components:unitFlags fromDate:date];

    return [comp year];
}

- (void)clearOldSections {
    // Need to clear old sessions first
    [self clearOldSessions];
    
    NSArray *sections = [handler getSections];
    
    for (Section *section in sections) {
        BOOL keep = NO;
        
        int year = [self getYear:[section startDate]];
        
        for (NSNumber *num in activeYears) {
            if ([num intValue] == year) {
                keep = YES;
            }
        }
        
        if (keep == NO) {
            AppLog(@"Remove section %@ with date %@", [section title], [section startDate]);
            [handler deleteSection:section];
        }

    }
}

- (void)clearOldSessions {
    NSArray *sessions = [handler getAllSessions];
    
	for (JZSession *session in sessions) {
        BOOL keep = NO;
        
        int year = [self getYear:[session startDate]];
        
        for (NSNumber *num in activeYears) {
            if ([num intValue] == year) {
                keep = YES;
            }
        }
        
        if (keep == NO) {
            AppLog(@"Remove session %@ with date %@", [session title], [session startDate]);
            [handler deleteSession:session];
        }
	}
}

@end
