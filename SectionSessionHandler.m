//
//  SectionSessionHandler.m
//  incogito
//
//  Created by Chris Searle on 15.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SectionSessionHandler.h"

#import "Section.h"
#import "JZSession.h"

@implementation SectionSessionHandler

@synthesize managedObjectContext;

- (NSArray *)getSections {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Section" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError *error;

	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

	NSArray *sections = [NSArray arrayWithArray:mutableFetchResults];
	
	return sections;
}

- (NSArray *)getSectionTitles {
	NSArray *sections = [self getSections];
	
	NSMutableArray *mutableSectionTitles = [[NSMutableArray alloc] initWithCapacity:[sections count]];
	
	for (Section *section in sections) {
		[mutableSectionTitles addObject:[section title]];
	}
	
	NSArray *sectionTitles = [NSArray arrayWithArray:mutableSectionTitles];
	
	return sectionTitles;
}

- (NSDictionary *)getSessions {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"room" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(active == %@)", [NSNumber numberWithBool:true]];
	
	[request setPredicate:predicate];
	
	NSError *error;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	NSMutableArray *section1Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section2Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section3Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section4Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section5Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section6Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section7Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section8Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section9Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section10Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section11Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section12Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section13Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section14Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section15Sessions = [[NSMutableArray alloc] init];
	
	for (JZSession *session in mutableFetchResults) {
		if ([self startDate:[session startDate] andEndDate:[session endDate]
				 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 09:00:00 +0100"]
						and:[[NSDate alloc] initWithString:@"2010-09-08 10:00:00 +0100"]]) {
			[section1Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 10:15:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 11:15:00 +0100"]]) {
			[section2Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 11:45:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 12:45:00 +0100"]]) {
			[section3Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 13:00:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 14:00:00 +0100"]]) {
			[section4Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 14:15:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 15:15:00 +0100"]]) {
			[section5Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 15:45:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 16:45:00 +0100"]]) {
			[section6Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 17:00:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 18:00:00 +0100"]]) {
			[section7Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 18:15:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 19:15:00 +0100"]]) {
			[section8Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 09:00:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 10:00:00 +0100"]]) {
			[section9Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 10:15:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 11:15:00 +0100"]]) {
			[section10Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 11:45:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 12:45:00 +0100"]]) {
			[section11Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 13:00:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 14:00:00 +0100"]]) {
			[section12Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 14:15:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 15:15:00 +0100"]]) {
			[section13Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 15:45:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 16:45:00 +0100"]]) {
			[section14Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 17:00:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 18:00:00 +0100"]]) {
			[section15Sessions addObject:session];
		} else {
			NSLog(@"Dates %@ %@ didn't find a match", [session startDate], [session endDate]);
		}
	}
	
	NSArray *keys = [self  getSectionTitles];
	NSArray *objects = [NSArray arrayWithObjects:section1Sessions,
						section2Sessions,
						section3Sessions,
						section4Sessions,
						section5Sessions,
						section6Sessions,
						section7Sessions,
						section8Sessions,
						section9Sessions,
						section10Sessions,
						section11Sessions,
						section12Sessions,
						section13Sessions,
						section14Sessions,
						section15Sessions,
						nil];
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	[mutableFetchResults release];
	[request release];
	
	return dictionary;
}

- (BOOL)startDate:(NSDate *)startDate andEndDate:(NSDate *)endDate areBetween:(NSDate *)earliestDate and:(NSDate *)latestDate {
	NSComparisonResult startCompare = [startDate compare:earliestDate];
	if (startCompare == NSOrderedAscending) {
		return false;
	}
	
	NSComparisonResult endCompare = [endDate compare:latestDate];
	if (endCompare == NSOrderedDescending) {
		return false;
	}
	
	return true;
}



@end
