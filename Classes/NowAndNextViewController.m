//
//  NowAndNextViewController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "NowAndNextViewController.h"
#import "SectionSessionHandler.h"

#import "IncogitoAppDelegate.h"
#import "Section.h"
#import "FlurryAPI.h"

@implementation NowAndNextViewController

@synthesize footers;

- (void) viewWillAppear:(BOOL)animated {
	[FlurryAPI logEvent:@"Showing Now and Next"];

	[self loadSessionData];
    
    [[self tv] reloadData];
}

- (void)loadSessionData {
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];
	
	[self setSessions:[handler getSessions]];
	
	NSMutableArray *titles = [[NSMutableArray alloc] init];
	NSMutableArray *footerTexts = [[NSMutableArray alloc] init];

#ifdef NOW_AND_NEXT_USE_TEST_DATE
	// In debug mode we will use the current time of day but always the first day of JZ. Otherwise we couldn't test until JZ started ;)
	NSDate *current = [[NSDate alloc] init];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	unsigned int unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit;
	NSDateComponents *comp = [calendar components:unitFlags fromDate:current];
	
	NSDate *now = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"2011-09-07 %02d:%02d:00 +0200", [comp hour], [comp minute]]];

	[current release];
#else
	NSDate *now = [[NSDate alloc] init];
#endif
	NSString *nowTitle = [handler getSectionTitleForDate:now];
	NSString *nextTitle = [handler getNextSectionTitleForDate:now];

	[now release];
	
	if (nil != nowTitle) {
		[footerTexts addObject:nowTitle];
		[titles addObject:@"Now"];
	}
	if (nil != nextTitle) {
		[footerTexts addObject:nextTitle];
		[titles addObject:@"Next"];
	}
	
	[self setSectionTitles:[[[NSArray alloc] initWithArray:titles] autorelease]];
	[self setFooters:[[[NSArray alloc] initWithArray:footerTexts] autorelease]];
	
	[titles release];
	[footerTexts release];
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
	[footers release];
    [super dealloc];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return [footers objectAtIndex:section];
}

- (NSString *)getSelectedSessionTitle:(NSInteger)section {
	return [footers objectAtIndex:section];
}

@end
