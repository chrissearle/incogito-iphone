//
//  SectionInitializer.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

@interface SectionInitializer : NSObject

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)removeSections;
- (void)initializeSections;
- (void)initializeSectionsWithRefresh:(BOOL)refreshFlag;
- (void)addSectionForDay:(int)day startingAt:(NSString *)startDate endingAt:(NSString *)endDate;
- (NSUInteger)getSectionCount;

@end
