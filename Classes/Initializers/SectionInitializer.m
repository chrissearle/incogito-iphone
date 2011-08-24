//
//  SectionInitializer.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SectionInitializer.h"
#import "Section.h"
#import "SessionDateConverter.h"

@implementation SectionInitializer

@synthesize managedObjectContext;

- (void) initializeSections {
	[self initializeSectionsWithRefresh:NO];
}

- (void) initializeSectionsWithRefresh:(BOOL)refreshFlag {
	AppLog(@"Start of initializeSections");
	
	if (refreshFlag) {
		[self removeSections];
	}
	
	if ([self getSectionCount] == 0) {
		AppLog(@"Adding sections");

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
	AppLog(@"Start of addSectionForDay:startingAt");
	
	Section *section = (Section *)[NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:self.managedObjectContext];
	
    
	NSDate *start = [SessionDateConverter dateFromString:startDate];
	NSDate *end = [SessionDateConverter dateFromString:endDate];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	unsigned int unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit;
	
	NSDateComponents *startComp = [calendar components:unitFlags fromDate:start];
	
	NSDateComponents *endComp = [calendar components:unitFlags fromDate:end];
	
	[section setTitle:[NSString stringWithFormat:@"Day %d: %02d:%02d - %02d:%02d", day,
					   [startComp hour], [startComp minute],
					   [endComp hour], [endComp minute]]];
	[section setStartDate:start];
	[section setEndDate:end];
    
    NSError* error;
    if(![managedObjectContext save:&error]) {
        AppLog(@"Failed to save to data store: %@", [error localizedDescription]);
        NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        if(detailedErrors != nil && [detailedErrors count] > 0) {
            for(NSError* detailedError in detailedErrors) {
                AppLog(@"  DetailedError: %@", [detailedError userInfo]);
            }
        }
        else {
            AppLog(@"  %@", [error userInfo]);
        }
    }
    
	AppLog(@"End of addSectionForDay:startingAt");
}

- (NSUInteger)getSectionCount {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Section" inManagedObjectContext:self.managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSError *error = nil;
	
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];
	
	if (nil != error) {
		[mutableFetchResults release];
		AppLog(@"%@:%@ Error fetching sections: %@", [self class], _cmd, [error localizedDescription]);
		return 0;
	}

	NSUInteger count = [mutableFetchResults count];
	
	[mutableFetchResults release];
	
	return count;
}


- (void)removeSections {
	AppLog(@"Removing sections");
	
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Section" inManagedObjectContext:self.managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSError *error = nil;
	
	NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
	
	if (nil != error) {
		AppLog(@"%@:%@ Error fetching sections: %@", [self class], _cmd, [error localizedDescription]);
		return;
	}

	AppLog(@"Removing sections start loop");
	
	for (NSManagedObject *section in array) {
		[self.managedObjectContext deleteObject:section];
	}
	
	AppLog(@"Removing sections end loop");
	
	error = nil;
	
	if (![self.managedObjectContext save:&error]) {
		if (nil != error) {
			AppLog(@"%@:%@ Error saving sections: %@", [self class], _cmd, [error localizedDescription]);
			return;
		}
	}
	
	AppLog(@"End of removing sections");
}

- (void) dealloc {
    [managedObjectContext release];
    
    [super dealloc];
}

@end
