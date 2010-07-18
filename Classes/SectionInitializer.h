//
//  SectionInitializer.h
//  incogito
//
//  Created by Chris Searle on 15.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

@interface SectionInitializer : NSObject {
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)removeSections;
- (void)initializeSections;
- (void)initializeSectionsWithRefresh:(BOOL)refreshFlag;
- (void)addSectionForDay:(int)day startingAt:(NSString *)startDate endingAt:(NSString *)endDate;
- (NSUInteger)getSectionCount;

@end
