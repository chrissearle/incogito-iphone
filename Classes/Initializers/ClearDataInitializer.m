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

    if (self) {
        activeYears = [[JavaZonePrefs activeYears] retain];
        handler = [ssHandler retain];
    }
    
    return self;
}

- (int) getYear:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit;
    NSDateComponents *comp = [calendar components:unitFlags fromDate:date];

    return [comp year];
}

- (void)clearOldSections {
    AppLog(@"Clearing sections");

    NSArray *sections = [self.handler getSections];
    
    for (Section *section in sections) {
        BOOL keep = NO;
        
        int year = [self getYear:[section startDate]];
        
        for (NSNumber *num in self.activeYears) {
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
    AppLog(@"Clearing sessions");

    NSArray *sessions = [self.handler getAllSessions];
    
	for (JZSession *session in sessions) {
        BOOL keep = NO;
        
        int year = [self getYear:[session startDate]];
        
        for (NSNumber *num in self.activeYears) {
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

- (void)clear {
    [self clearOldSessions];
    [self clearOldSections];
}


- (void)dealloc {
    [activeYears release];
    [handler release];
    
    [super dealloc];
}

@end
