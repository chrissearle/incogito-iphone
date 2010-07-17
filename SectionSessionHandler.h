//
//  SectionSessionHandler.h
//  incogito
//
//  Created by Chris Searle on 15.07.10.
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
- (NSArray *)getSessionsForSection:(Section *)section;
- (NSDictionary *)getFavouriteSessions;
- (NSArray *)getFavouriteSessionsForSection:(Section *)section;

- (NSUInteger)getActiveSessionCount;

- (void) setFavouriteForSession:(JZSession *)session withBoolean:(BOOL)favouriteFlag;

@end
