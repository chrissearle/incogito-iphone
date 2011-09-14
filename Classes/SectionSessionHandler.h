//
//  SectionSessionHandler.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Section;
@class JZSession;

@interface SectionSessionHandler : NSObject 

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

// Clear Data

- (NSArray *)getSections;
- (NSArray *)getAllSessions;
- (void)deleteSession:(JZSession *)session;
- (void)deleteSection:(Section *)section;

// List

- (NSString *)getSectionTitleForDate:(NSDate *)date;
- (NSString *)getNextSectionTitleForDate:(NSDate *)date;
- (NSDictionary *)getSessionsMatching:(NSString *)search andLevel:(NSString *)level andLabel:(NSString *)label withFavourites:(BOOL)limitToFavourites;
- (NSUInteger)getActiveSessionCount;

// Detail

- (JZSession *)getSessionForJZId:(NSString *)jzId;
- (void) setFavouriteForSession:(JZSession *)session withBoolean:(BOOL)favouriteFlag;

// Detail and List

- (void) toggleFavouriteForSession:(NSString *)jzId;

// Filter
- (NSDictionary *)getUniqueLabels;

@end
