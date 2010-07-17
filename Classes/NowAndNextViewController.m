    //
//  NowAndNextViewController.m
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "NowAndNextViewController.h"
#import "SectionSessionHandler.h"

#import "IncogitoAppDelegate.h"
#import "Section.h"

@implementation NowAndNextViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self loadSessionData];
}

- (void)loadSessionData {
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];
	
	sessions = [[handler getSessions] retain];
	
	NSMutableArray *titles = [[NSMutableArray alloc] init];

#ifdef NOW_AND_NEXT_USE_TEST_DATE
	// In debug mode we will use the current time of day but always the first day of JZ. Otherwise we couldn't test until JZ started ;)
	NSDate *current = [[NSDate alloc] init];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	unsigned int unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit;
	NSDateComponents *comp = [calendar components:unitFlags fromDate:current];
	
	NSDate *now = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"2010-09-08 %02d:%02d:00 +0200", [comp hour], [comp minute]]];

	[current release];
#else
	NSDate *now = [[NSDate alloc] init];
#endif

	Section *section = [handler getSectionForDate:now];
	[now release];
	
	if (nil != section) {
		[titles addObject:[section title]];
		
		NSDate *next = [[NSDate alloc] initWithTimeInterval:1801 sinceDate:[section endDate]];
		section = [handler getSectionForDate:next];
		[next release];
		
		if (nil != section) {
			[titles addObject:[section title]];
		}
	}
	
	sectionTitles = [[[NSArray alloc] initWithArray:titles] retain];
	
	[titles release];
}

- (void)viewWillAppear:(BOOL)animated {
	[self loadSessionData];
	
	[tv reloadData];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
