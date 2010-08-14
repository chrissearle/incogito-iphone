//
//  SectionSessionHandler.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Section;
@class JZSession;

@interface SectionSessionHandler : NSObject {
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (NSArray *)getSections;
- (NSString *)getSectionTitleForDate:(NSDate *)date;
- (NSString *)getNextSectionTitleForDate:(NSDate *)date;
- (JZSession *)getSessionForJZId:(NSString *)jzId;

- (NSDictionary *)getSessions;
- (NSDictionary *)getSessionsMatching:(NSString *)search;
- (NSArray *)getSessionsForSection:(Section *)section;
- (NSArray *)getSessionsForSection:(Section *)section matching:(NSString *)search;
- (NSDictionary *)getFavouriteSessions;
- (NSArray *)getFavouriteSessionsForSection:(Section *)section;

- (NSUInteger)getActiveSessionCount;

- (void) setFavouriteForSession:(JZSession *)session withBoolean:(BOOL)favouriteFlag;

- (NSDictionary *)getUniqueLabels;
- (NSString *)getStoredFilter;
- (NSArray *)filterSessionList:(NSArray *)sessions;

@end
