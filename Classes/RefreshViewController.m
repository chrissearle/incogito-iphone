    //
//  RefreshViewController.m
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "RefreshViewController.h"
#import "IncogitoAppDelegate.h"
#import "JavazoneSessionsRetriever.h"

@implementation RefreshViewController

@synthesize spinner;
@synthesize refreshStatus;
@synthesize appDelegate;

NSInteger sessionCount;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setAppDelegate:[[UIApplication sharedApplication] delegate]];

	[refreshStatus setText:@"If the JavaZone programme has been updated and no longer matches the session list you have then you can update the list by clicking the sync button above."];
	[spinner stopAnimating];
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
	[spinner release];
    [super dealloc];
}

#pragma mark -
#pragma mark Actions

- (IBAction)refresh:(id)sender {
	[refreshStatus setText:@""];
	[spinner startAnimating];
	
	[NSThread detachNewThreadSelector:@selector(refreshSessions) toTarget:self withObject:nil];
}

- (void) refreshSessions {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	JavazoneSessionsRetriever *retriever = [[[JavazoneSessionsRetriever alloc] init] autorelease];
	
	retriever.managedObjectContext = [appDelegate managedObjectContext];
		
	sessionCount = [retriever retrieveSessionsWithUrl:@"http://javazone.no/incogito10/rest/events/JavaZone%202010/sessions"];
	[self performSelectorOnMainThread:@selector(taskDone:) withObject:nil waitUntilDone:NO];
	[pool drain];
}

// This will be called in the context of the main thread, so you can do any required UI interaction here
- (void)taskDone:(id)arg {
	[spinner stopAnimating];

	NSString *status;
	if (sessionCount == 0) {
		status = [[NSString alloc] initWithString:@"Unable to connect to JavaZone website."];
		[refreshStatus setText:status];
	} else {
		status = [[NSString alloc] initWithFormat:@"Sessions synchronized with JavaZone. %d sessions available.", sessionCount];
		[refreshStatus setText:status];
	}

	[status release];
	
	[appDelegate refreshViewData];
}


@end
