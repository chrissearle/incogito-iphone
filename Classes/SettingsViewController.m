//
//  SettingsViewController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SettingsViewController.h"
#import "IncogitoAppDelegate.h"
#import "SectionSessionHandler.h"
#import "RefreshCommonViewController.h"

@implementation SettingsViewController

@synthesize labels;
@synthesize picker;
@synthesize appDelegate;

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

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setAppDelegate:[[UIApplication sharedApplication] delegate]];

	[self loadData];
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
	[labels release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [[[self labels] allKeys] count] + 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	if (nil == view) {
		view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 260, 32)] autorelease];
		
		UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 11.0, 10, 10)];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, 0.0, 228, 32)];
		
		[label setBackgroundColor:[UIColor clearColor]];
		[label setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
		
		[view addSubview:image];
		[view addSubview:label];
		
		[image release];
		[label release];
	}
	
	for (UIView *subview in view.subviews) {
		if ([subview class] == [UILabel class]) {
			UILabel *label = (UILabel *)subview;
			if (row == 0) {
				[label setText:@"All"];
			} else {
				NSArray *keys = [[labels allKeys] sortedArrayUsingSelector:@selector(compare:)];
				[label setText:[labels objectForKey:[keys objectAtIndex:(row - 1)]]];
			}
		}
		
		if ([subview class] == [UIImageView class]) {
			UIImageView *image = (UIImageView *)subview;
			if (row == 0) {
				[image setImage:[UIImage imageNamed:@"all.png"]];
			} else {
				NSArray *keys = [[labels allKeys] sortedArrayUsingSelector:@selector(compare:)];
				
				UIImage *imageFile = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [keys objectAtIndex:(row - 1)]]];
				
				if (nil == imageFile) {
					imageFile = [UIImage imageNamed:@"all.png"];
				}
				
				[image setImage:imageFile];
			}
		}
	}
	
	return view;
}

- (IBAction)filter:(id)sender {
	// Read current picker setting
	NSArray *values = [[labels allValues] sortedArrayUsingSelector:@selector(compare:)];
	
	int index = [picker selectedRowInComponent:0];
	
	NSString *label = @"All";
	
	NSString *messageTitle = @"Session filter cleared";
	NSString *message = @"Showing all sessions.";
	
	if (index > 0) {
		label = [values objectAtIndex:(index - 1)];

		messageTitle = @"Session filter applied";
		message = [NSString stringWithFormat:@"Showing only %@. This setting will be remembered - if you can't see sessions you expect to see - remember to check back here.", label];
	}

	// Store pref
	[appDelegate setLabelFilter:label];
	
	// Refresh views
	[appDelegate refreshViewData];

	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle: messageTitle
						  message: message
						  delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (IBAction)sync:(id)sender {
	RefreshCommonViewController *controller = [[RefreshCommonViewController alloc] initWithNibName:@"Update" bundle:[NSBundle mainBundle]];
	[controller setFirstTimeTextVisibility:NO];
	[self.tabBarController presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)refreshPicker {
	[self loadData];

	[picker reloadAllComponents];
}

- (void)loadData {
	[self setLabels:[appDelegate.sectionSessionHandler getUniqueLabels]];
	
	// Set picker index
	NSString *savedKey = [appDelegate getLabelFilter];
	
	NSArray *values = [[labels allValues] sortedArrayUsingSelector:@selector(compare:)];
	
	int index = 0;
	if ([values containsObject:savedKey]) {
		NSArray *sortedValues = [values sortedArrayUsingSelector:@selector(compare:)];
		index = [sortedValues indexOfObject:savedKey] + 1;
	}
	[picker selectRow:index inComponent:0 animated:YES];
}

@end
