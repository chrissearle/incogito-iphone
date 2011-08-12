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

- (void)viewWillAppear:(BOOL)animated {
	[FlurryAPI logEvent:@"Showing Favourites"];
}

- (void)loadSessionData {
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];
	
	[self setSessions:[handler getFavouriteSessions]];
	
	NSMutableArray *titles = [NSMutableArray arrayWithArray:[sessions allKeys]];
	
	[titles sortUsingSelector:@selector(compare:)];
	
	[self setSectionTitles:[[[NSArray alloc] initWithArray:titles] autorelease]];
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
