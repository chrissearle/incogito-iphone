//
//  MyProgrammeViewController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "MyProgrammeViewController.h"
#import "IncogitoAppDelegate.h"
#import "SectionSessionHandler.h"

@implementation MyProgrammeViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[self loadSessionData];
}

- (void)loadSessionData {
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];
	
	sessions = [[handler getFavouriteSessions] retain];
	
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

@end
