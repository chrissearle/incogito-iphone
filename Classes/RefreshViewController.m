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

- (void)viewDidLoad {
    [super viewDidLoad];

	[spinner stopAnimating];
	[refreshStatus setText:@"If the JavaZone programme has been updated and no longer matches the session list you have then you can update the list by clicking the sync button above."];
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

#pragma mark -
#pragma mark Actions

- (IBAction)refresh:(id)sender {
	[refreshStatus setText:@""];
	[spinner startAnimating];
	
#ifdef LOG_FUNCTION_TIMES
NSLog(@"%@ Start of refresh sync", [[[NSDate alloc] init] autorelease]);
#endif
	
	[NSThread detachNewThreadSelector:@selector(refreshSessions) toTarget:self withObject:nil];
}

@end
