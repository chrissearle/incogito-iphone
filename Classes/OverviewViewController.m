    //
//  OverviewViewController.m
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "OverviewViewController.h"
#import "IncogitoAppDelegate.h"
#import "JZSession.h"

@implementation OverviewViewController

@synthesize sectionTitles;
@synthesize sessions;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	sectionTitles = [[NSArray alloc] initWithArray:[appDelegate getSectionTitles]];
	sessions = [appDelegate getSessions];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[sessions dealloc];
	[sectionTitles dealloc];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *sectionName = [sectionTitles objectAtIndex:section];
	
	NSArray *sectionSessions = [sessions objectForKey:sectionName];
	
	if (nil == sectionSessions) {
		return 0;
	}
	
	return [sectionSessions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *sectionName = [sectionTitles objectAtIndex:indexPath.section];
	
	NSArray *sectionSessions = [sessions objectForKey:sectionName];

	JZSession *session = [sectionSessions objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
	
	if (nil == cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sessionCell"];
	}
	
	cell.textLabel.text = session.title;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Room %@", session.room];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [sectionTitles objectAtIndex:section];
}

@end
