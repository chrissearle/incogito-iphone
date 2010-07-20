//
//  UpdateViewController.m
//  incogito
//
//  Created by Chris Searle on 16.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "UpdateViewController.h"
#import "JavazoneSessionsRetriever.h"
#import "IncogitoAppDelegate.h"

@implementation UpdateViewController

@synthesize spinner;
@synthesize refreshStatus;
@synthesize appDelegate;

NSInteger sessionCount;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setAppDelegate:[[UIApplication sharedApplication] delegate]];

	[refreshStatus setText:@""];
	[spinner startAnimating];
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Start of update sync", [[[NSDate alloc] init] autorelease]);
#endif
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
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ End of update sync", [[[NSDate alloc] init] autorelease]);
#endif
	[spinner stopAnimating];
	
	NSString *status;
	if (sessionCount == 0) {
		status = [[NSString alloc] initWithString:@"Unable to connect to JavaZone website."];
		[refreshStatus setText:status];
	} else {
		status = [[NSString alloc] initWithFormat:@"%d sessions downloaded from JavaZone website.", sessionCount];
		[refreshStatus setText:status];
	}
	[status release];
	
	[appDelegate refreshViewData];
	
	[closeButton setEnabled:YES];
}

- (void) closeModalViewController:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
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

@end
