//
//  SectionInitializer.m
//  incogito
//
//  Created by Chris Searle on 15.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SectionInitializer.h"
#import "Section.h"

@implementation SectionInitializer

@synthesize managedObjectContext;

- (void) initializeSections {
	[self initializeSectionsWithRefresh:NO];
}

- (void) initializeSectionsWithRefresh:(BOOL)refreshFlag {
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Start of initializeSections", [[[NSDate alloc] init] autorelease]);
#endif
	
	if (refreshFlag) {
		[self removeSections];
	}
	
	if ([self getSectionCount] == 0) {
#ifdef LOG_FUNCTION_TIMES
		NSLog(@"%@ Adding sections", [[[NSDate alloc] init] autorelease]);
#endif
		[self addSectionForDay:1 startingAt:@"2010-09-08 09:00:00 +0200" endingAt:@"2010-09-08 10:00:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2010-09-08 10:15:00 +0200" endingAt:@"2010-09-08 11:15:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2010-09-08 11:45:00 +0200" endingAt:@"2010-09-08 12:45:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2010-09-08 13:00:00 +0200" endingAt:@"2010-09-08 14:00:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2010-09-08 14:15:00 +0200" endingAt:@"2010-09-08 15:15:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2010-09-08 15:45:00 +0200" endingAt:@"2010-09-08 16:45:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2010-09-08 17:00:00 +0200" endingAt:@"2010-09-08 18:00:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2010-09-08 18:15:00 +0200" endingAt:@"2010-09-08 19:15:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2010-09-09 09:00:00 +0200" endingAt:@"2010-09-09 10:00:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2010-09-09 10:15:00 +0200" endingAt:@"2010-09-09 11:15:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2010-09-09 11:45:00 +0200" endingAt:@"2010-09-09 12:45:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2010-09-09 13:00:00 +0200" endingAt:@"2010-09-09 14:00:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2010-09-09 14:15:00 +0200" endingAt:@"2010-09-09 15:15:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2010-09-09 15:45:00 +0200" endingAt:@"2010-09-09 16:45:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2010-09-09 17:00:00 +0200" endingAt:@"2010-09-09 18:00:00 +0200"];
	}
}

- (void)addSectionForDay:(int)day startingAt:(NSString *)startDate endingAt:(NSString *)endDate {
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Start of addSectionForDay:startingAt", [[[NSDate alloc] init] autorelease]);
#endif
	
	Section *section = (Section *)[NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:managedObjectContext];
	
	NSDate *start = [[NSDate alloc] initWithString:startDate];
	NSDate *end = [[NSDate alloc] initWithString:endDate];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	unsigned int unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit;
	
	NSDateComponents *startComp = [calendar components:unitFlags fromDate:start];
	
	NSDateComponents *endComp = [calendar components:unitFlags fromDate:end];
	
	[section setTitle:[NSString stringWithFormat:@"Day %d: %02d:%02d - %02d:%02d", day,
					   [startComp hour], [startComp minute],
					   [endComp hour], [endComp minute]]];
	[section setStartDate:start];
	[section setEndDate:end];
	
	[start release];
	[end release];
	
	NSError *error;
	
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ End of addSectionForDay:startingAt", [[[NSDate alloc] init] autorelease]);
#endif
	
}

- (NSUInteger)getSectionCount {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Section" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSError *error;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	NSUInteger count = [mutableFetchResults count];
	
	[mutableFetchResults release];
	[request release];
	
	return count;
}


- (void)removeSections {
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Removing sections", [[[NSDate alloc] init] autorelease]);
#endif
	
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Section" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSError *error;
	
	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Removing sections start loop", [[[NSDate alloc] init] autorelease]);
#endif
	
	for (NSManagedObject *section in array) {
		[managedObjectContext deleteObject:section];
	}
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Removing sections end loop", [[[NSDate alloc] init] autorelease]);
#endif
	
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ End of removing sections", [[[NSDate alloc] init] autorelease]);
#endif
}

@end
