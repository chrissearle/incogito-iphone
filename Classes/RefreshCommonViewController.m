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
@synthesize progressView;
@synthesize firstTimeText;

NSInteger sessionCount;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[progressView setHidden:YES];
	[closeButton setEnabled:NO];
	greyView.frame = closeButton.frame;
	greyView.alpha = 0.6;
	[[greyView layer] setCornerRadius:10.0f];
	[[greyView layer] setMasksToBounds:YES];
	[greyView setHidden:NO];

	[self setAppDelegate:[[UIApplication sharedApplication] delegate]];

	[spinner startAnimating];
	[refreshStatus setText:@""];
	
	firstTimeText.hidden = hideFirstTimeText;

		
#ifdef LOG_FUNCTION_TIMES
		NSLog(@"%@ Start of update sync", [[[NSDate alloc] init] autorelease]);
#endif
	[NSThread detachNewThreadSelector:@selector(refreshSessions) toTarget:self withObject:nil];
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
	retriever.refreshCommonViewController = self;
	
	sessionCount = [retriever retrieveSessionsWithUrl:@"http://javazone.no/incogito10/rest/events/JavaZone%202010/sessions"];
	[self performSelectorOnMainThread:@selector(taskDone:) withObject:nil waitUntilDone:NO];
	[pool drain];
}

- (void)taskDone:(id)arg {
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ End of sync", [[[NSDate alloc] init] autorelease]);
#endif
	
	[progressView setHidden:YES];
	
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

	[greyView setHidden:YES];
	[closeButton setEnabled:YES];
}

- (void)showProgressBar:(id)arg {
	[spinner stopAnimating];
	[progressView setProgress:0.0];
	[progressView setHidden:NO];
}

- (void)setProgressTo:(id)progress {
	NSNumber *value = (NSNumber *)progress;
	
	[progressView setProgress:[value floatValue]];
}

- (void) closeModalViewController:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) setFirstTimeTextVisibility:(BOOL) visibility {
	hideFirstTimeText = !visibility;
}

@end
