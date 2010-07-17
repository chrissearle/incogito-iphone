//
//  OverviewViewController.m
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "OverviewViewController.h"
#import "IncogitoAppDelegate.h"
#import "SectionSessionHandler.h"
#import "UpdateViewController.h"

@implementation OverviewViewController

@synthesize tableView = _tableView;

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];
	
	NSUInteger count = [handler getActiveSessionCount];
	
	if (count == 0) {
		UpdateViewController *controller = [[UpdateViewController alloc] initWithNibName:@"Update" bundle:[NSBundle mainBundle]];
		[self.tabBarController presentModalViewController:controller animated:YES];
		[controller release];
	}
	
	sessions = [[handler getSessions] retain];

	NSMutableArray *titles = [NSMutableArray arrayWithArray:[sessions allKeys]];
	
	[titles sortUsingSelector:@selector(compare:)];
	
	sectionTitles = [[[NSArray alloc] initWithArray:titles] retain];
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

- (void)reloadSessionData {
	[_tableView reloadData];
}

@end
