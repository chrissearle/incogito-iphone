    //
//  RefreshCommonViewController.m
//  incogito
//
//  Created by Chris Searle on 27.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "RefreshCommonViewController.h"
#import "IncogitoAppDelegate.h"
#import "JavazoneSessionsRetriever.h"

@implementation RefreshCommonViewController

@synthesize spinner;
@synthesize refreshStatus;
@synthesize appDelegate;

NSInteger sessionCount;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setAppDelegate:[[UIApplication sharedApplication] delegate]];
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
	[spinner release];
    [super dealloc];
}

- (void) refreshSessions {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	JavazoneSessionsRetriever *retriever = [[[JavazoneSessionsRetriever alloc] init] autorelease];
	
	retriever.managedObjectContext = [appDelegate managedObjectContext];
	
	sessionCount = [retriever retrieveSessionsWithUrl:@"http://javazone.no/incogito10/rest/events/JavaZone%202010/sessions"];
	[self performSelectorOnMainThread:@selector(taskDone:) withObject:nil waitUntilDone:NO];
	[pool drain];
}

- (void)taskDone:(id)arg {
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ End of sync", [[[NSDate alloc] init] autorelease]);
#endif
	
	[spinner stopAnimating];
	
	NSString *status;
	if (sessionCount == 0) {
		status = [[NSString alloc] initWithString:@"Unable to connect to JavaZone website."];
		[refreshStatus setText:status];
	} else {
		status = [[NSString alloc] initWithFormat:@"Sessions retrieved from JavaZone. %d sessions available.", sessionCount];
		[refreshStatus setText:status];
	}
	
	[status release];
	
	[appDelegate refreshViewData];
}



@end
