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

- (NSArray *)getSectionTitles {
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
	
	NSMutableArray *mutableSectionList = [[NSMutableArray alloc] initWithCapacity:[mutableFetchResults count]];
	
	for (Section *section in mutableFetchResults) {
		[mutableSectionList addObject:[section title]];
	}
	
	NSArray *sections = [NSArray arrayWithArray:mutableSectionList];
	
	return sections;
}



@end
