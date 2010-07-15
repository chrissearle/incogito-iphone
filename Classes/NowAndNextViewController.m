    //
//  NowAndNextViewController.m
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "NowAndNextViewController.h"
#import "Section.h"
#import "JZSession.h"
#import "SectionSessionHandler.h"
#import "IncogitoAppDelegate.h"
#import "DetailedSessionViewController.h"

@implementation NowAndNextViewController

@synthesize tableView = _tableView;
@synthesize sectionTitles;
@synthesize sessions;
@synthesize sectionSessions;

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
	
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];
	
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
	
	sectionTitles = [NSArray arrayWithArray:titles];
	[titles release];
	
	sessions = [[handler getSessions] retain];
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
	[sectionName release];
	[sectionSessions release];
	[sessions release];
	[sectionTitles release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	sectionName = [sectionTitles objectAtIndex:section];
	
	sectionSessions = [sessions objectForKey:sectionName];
	
	if (nil == sectionSessions) {
		return 0;
	}
	
	return [sectionSessions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	sectionName = [sectionTitles objectAtIndex:indexPath.section];
	
	sectionSessions = [sessions objectForKey:sectionName];
	
	JZSession *session = [sectionSessions objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
	
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
	DetailedSessionViewController *controller = [[DetailedSessionViewController alloc] initWithNibName:@"DetailedSessionView" bundle:[NSBundle mainBundle]];
	controller.session = [sectionSessions objectAtIndex:indexPath.row];
	
	NSLog(@"row %d title %@", indexPath.row, controller.session.title);
	
	[self.tabBarController presentModalViewController:controller animated:YES];
	[controller release];
}

@end
