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

@implementation NowAndNextViewController

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
	
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];
	
	NSMutableArray *titles = [[NSMutableArray alloc] init];
	
	// NSDate *now = [[NSDate alloc] init];
	// Careful to get +0100 here.
	// Testing
	NSDate *now = [[NSDate alloc] initWithString:@"2010-09-08 10:33:00 +0100"];
	Section *section = [handler getSectionForDate:now];
	[now release];
	
	if (nil != section) {
		[titles addObject:[section title]];
		
		NSDate *next = [[NSDate alloc] initWithTimeInterval:1801 sinceDate:[section endDate]];
		
		[section release];

		section = [handler getSectionForDate:next];
		[next release];
		
		if (nil != section) {
			[titles addObject:[section title]];
		}
	}
	
	sectionTitles = [NSArray arrayWithArray:titles];
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
	
	NSMutableArray *speakerNames = [[NSMutableArray alloc] initWithCapacity:[session.speakers count]];
	
	for (JZSessionBio *bio in session.speakers) {
		[speakerNames addObject:[bio name]];
	}
	
	cell.textLabel.text = session.title;
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Room %@ - %@", session.room, [speakerNames componentsJoinedByString:@", "]];
	cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [sectionTitles objectAtIndex:section];
}

@end
