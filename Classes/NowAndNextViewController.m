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
	
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];

	sessions = [[handler getSessions] retain];
	
	NSMutableArray *titles = [[NSMutableArray alloc] init];
	
	//NSDate *now = [[NSDate alloc] init];
	//For testing
	NSDate *now = [[NSDate alloc] initWithString:@"2010-09-08 10:33:00 +0200"];
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
