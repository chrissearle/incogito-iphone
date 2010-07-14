    //
//  RefreshViewController.m
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "RefreshViewController.h"
#import "IncogitoAppDelegate.h"


@implementation RefreshViewController

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
	
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[self.view addSubview:spinner];
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
	[spinner dealloc];
    [super dealloc];
}

#pragma mark -
#pragma mark Actions

- (IBAction)refresh:(id)sender {
	[spinner startAnimating];
	NSInteger sessionCount = [appDelegate refreshData];
	[spinner stopAnimating];

	
	if (0 == sessionCount) {
		refreshComplete = [[UIAlertView alloc] initWithTitle:@"Refresh Failed" message:@"Unable to connect to JavaZone website."
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	} else {
		refreshComplete = [[UIAlertView alloc] initWithTitle:@"Refresh Complete" message:[NSString stringWithFormat:@"%d sessions downloaded from JavaZone website.", sessionCount]
									  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	}

	[refreshComplete show];
	
/*
 This causes a bad access crash - do I not need to dealloc an alert view?
	[refreshComplete dealloc];
 */
}

@end
