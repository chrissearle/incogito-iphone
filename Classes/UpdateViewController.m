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

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[spinner startAnimating];
	[refreshStatus setText:@""];

#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Start of update sync", [[[NSDate alloc] init] autorelease]);
#endif
	[NSThread detachNewThreadSelector:@selector(refreshSessions) toTarget:self withObject:nil];
}

// This will be called in the context of the main thread, so you can do any required UI interaction here
- (void)taskDone:(id)arg {
	[super taskDone:arg];
	
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
    [super dealloc];
}

@end
