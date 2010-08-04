    //
//  SessionCommonViewController.m
//  incogito
//
//  Created by Chris Searle on 17.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SessionCommonViewController.h"
#import "JZSession.h"
#import "JZSessionBio.h"
#import "DetailedSessionViewController.h"
#import "IncogitoAppDelegate.h"

@implementation SessionCommonViewController

@synthesize sectionTitles;
@synthesize sessions;
@synthesize tv;
@synthesize appDelegate;

- (void) loadSessionData {
	// Stub
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setAppDelegate:[[UIApplication sharedApplication] delegate]];
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

- (NSString *)getSelectedSessionTitle:(NSInteger)section {
	return [sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *sectionName = [self getSelectedSessionTitle:section];
	
	if ([[sessions allKeys] containsObject:sectionName]) {
		NSArray *sectionSessions = [sessions objectForKey:sectionName];
		
		return [sectionSessions count];
	} else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	JZSession *session = [[sessions objectForKey:[self getSelectedSessionTitle:indexPath.section]] objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
	
	if (nil == cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sessionCell"];

		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
		cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	}
	
	NSMutableArray *speakerNames = [[NSMutableArray alloc] initWithCapacity:[session.speakers count]];
	
	for (JZSessionBio *bio in session.speakers) {
		[speakerNames addObject:[bio name]];
	}
	
	cell.textLabel.text = session.title;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Room %@ - %@", session.room, [speakerNames componentsJoinedByString:@", "]];

	[speakerNames release];
	
	UIImageView *imageView = [cell imageView];
	
	[imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [session level]]]];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [sectionTitles objectAtIndex:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *sectionTitle = [self getSelectedSessionTitle:indexPath.section];
	
	DetailedSessionViewController *controller = [[DetailedSessionViewController alloc] initWithNibName:@"DetailedSessionView" bundle:[NSBundle mainBundle]];
	controller.session = [[sessions objectForKey:sectionTitle] objectAtIndex:indexPath.row];
	
	[self.tabBarController presentModalViewController:controller animated:YES];
	[controller release];
}

@end
