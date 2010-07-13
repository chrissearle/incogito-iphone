//
//  sessionViewController.m
//  incogito
//
//  Created by Chris Searle on 13.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SessionViewController.h"
#import "JZSession.h"


@implementation SessionViewController

@synthesize managedObjectContext;
@synthesize sessionsArray;


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
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	[request setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(active = %@)", [NSNumber numberWithBool:true]];
	
	[request setPredicate:predicate];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	[self setSessionsArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
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
#pragma mark Table View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"Loading table with %d entries", [sessionsArray count]);
	
	return [sessionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Asked for row %d", indexPath.row);

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"session"];
	
	if (nil == cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"session"] autorelease];
	}
	
	JZSession *session = (JZSession *)[sessionsArray objectAtIndex:indexPath.row];

	NSLog(@"Adding row %d %@ %@", indexPath.row, [session title], [session jzId]);
	
    cell.textLabel.text = [NSString stringWithFormat:@"(%@) %@", [session room], [session title]];
	
    cell.detailTextLabel.text = [session jzId];
	
	return cell;
}

@end
