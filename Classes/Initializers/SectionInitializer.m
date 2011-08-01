//
//  SectionInitializer.m
//
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
		[self addSectionForDay:1 startingAt:@"2011-09-07 09:00:00 +0200" endingAt:@"2011-09-07 10:00:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2011-09-07 10:20:00 +0200" endingAt:@"2011-09-07 11:20:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2011-09-07 11:40:00 +0200" endingAt:@"2011-09-07 12:40:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2011-09-07 13:00:00 +0200" endingAt:@"2011-09-07 14:00:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2011-09-07 14:20:00 +0200" endingAt:@"2011-09-07 15:20:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2011-09-07 15:40:00 +0200" endingAt:@"2011-09-07 16:40:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2011-09-07 17:00:00 +0200" endingAt:@"2011-09-07 18:00:00 +0200"];
		[self addSectionForDay:1 startingAt:@"2011-09-07 18:20:00 +0200" endingAt:@"2011-09-07 19:20:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2011-09-08 09:00:00 +0200" endingAt:@"2011-09-08 10:00:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2011-09-08 10:20:00 +0200" endingAt:@"2011-09-08 11:20:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2011-09-08 11:40:00 +0200" endingAt:@"2011-09-08 12:40:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2011-09-08 13:00:00 +0200" endingAt:@"2011-09-08 14:00:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2011-09-08 14:20:00 +0200" endingAt:@"2011-09-08 15:20:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2011-09-08 15:40:00 +0200" endingAt:@"2011-09-08 16:40:00 +0200"];
		[self addSectionForDay:2 startingAt:@"2011-09-08 17:00:00 +0200" endingAt:@"2011-09-08 18:00:00 +0200"];
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
	
	NSError *error = nil;
	
	if (![managedObjectContext save:&error]) {
		if (nil != error) {
			NSLog(@"%@:%@ Error saving sections: %@", [self class], _cmd, [error localizedDescription]);
			return;
		}
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
	
	NSError *error = nil;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];
	
	if (nil != error) {
		[mutableFetchResults release];
		NSLog(@"%@:%@ Error fetching sections: %@", [self class], _cmd, [error localizedDescription]);
		return 0;
	}

	NSUInteger count = [mutableFetchResults count];
	
	[mutableFetchResults release];
	
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
	
	NSError *error = nil;
	
	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	
	if (nil != error) {
		NSLog(@"%@:%@ Error fetching sections: %@", [self class], _cmd, [error localizedDescription]);
		return;
	}

#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Removing sections start loop", [[[NSDate alloc] init] autorelease]);
#endif
	
	for (NSManagedObject *section in array) {
		[managedObjectContext deleteObject:section];
	}
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Removing sections end loop", [[[NSDate alloc] init] autorelease]);
#endif
	
	error = nil;
	
	if (![managedObjectContext save:&error]) {
		if (nil != error) {
			NSLog(@"%@:%@ Error saving sections: %@", [self class], _cmd, [error localizedDescription]);
			return;
		}
	}
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ End of removing sections", [[[NSDate alloc] init] autorelease]);
#endif
}

@end
