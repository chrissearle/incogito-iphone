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
#import "JZSessionBio.h"
#import "SectionSessionHandler.h"
#import "DetailedSessionViewController.h"
#import "UpdateViewController.h"

@implementation OverviewViewController


@synthesize tableView = _tableView;
@synthesize sectionTitles;
@synthesize sessions;


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
	[sessions release];
	[sectionTitles release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *sectionName = [sectionTitles objectAtIndex:section];
	
	if ([[sessions allKeys] containsObject:sectionName]) {
		NSArray *sectionSessions = [sessions objectForKey:sectionName];
	
		return [sectionSessions count];
	} else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	JZSession *session = [[sessions objectForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
	
	if (nil == cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sessionCell"];
	}
	
	NSMutableArray *speakerNames = [[NSMutableArray alloc] initWithCapacity:[session.speakers count]];
	
	for (JZSessionBio *bio in session.speakers) {
		[speakerNames addObject:[bio name]];
	}
	
	cell.textLabel.text = session.title;
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Room %@ - %@", session.room, [speakerNames componentsJoinedByString:@", "]];
	[speakerNames release];
	cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [sectionTitles objectAtIndex:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *sectionTitle = [sectionTitles objectAtIndex:indexPath.section];
	
	DetailedSessionViewController *controller = [[DetailedSessionViewController alloc] initWithNibName:@"DetailedSessionView" bundle:[NSBundle mainBundle]];
	controller.session = [[sessions objectForKey:sectionTitle] objectAtIndex:indexPath.row];

	NSLog(@"row %d title %@", indexPath.row, controller.session.title);

	[self.tabBarController presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)reloadSessionData {
	[_tableView reloadData];
}

@end
