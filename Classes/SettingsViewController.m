    //
//  SettingsViewController.m
//  incogito
//
//  Created by Chris Searle on 06.08.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SettingsViewController.h"
#import "IncogitoAppDelegate.h"

@implementation SettingsViewController

@synthesize labels;

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
	
	// Retrieve all keys/vals from CoreData instead of this hard coded set
	
	NSArray *keys = [[NSArray alloc] initWithObjects:@"enterprise-architecture-and-integration",
					 @"agile-and-software-engineering",
					 @"core-java",
					 @"domain-driven-design",
					 @"architecture-and-design",
					 @"alternative-languages",
					 @"frontend-technologies",
					 @"innovative-use-of-it",
					 @"tools-and-techniques",
					 @"experience-reports",
					 @"web-as-a-platform",
					 @"java-frameworks",
					 @"embedded",
					 @"gaming",
					 @"green-it",
					 @"mobile",
					 @"usability",
					 nil];
	
	NSArray *values = [[NSArray alloc] initWithObjects:@"Enterprise Architecture and Integration",
					   @"Agile and Software Engineering",
					   @"Core Java",
					   @"Domain-driven design",
					   @"Architecture and Design",
					   @"Alternative Languages",
					   @"Frontend Technologies",
					   @"Innovative use of IT",
					   @"Tools and Techniques",
					   @"Experience Reports",
					   @"Web as a Platform",
					   @"Java Frameworks",
					   @"Embedded",
					   @"Gaming",
					   @"Green IT",
					   @"Mobile",
					   @"Usability",
					   nil];
	
	[self setLabels:[[NSDictionary alloc] initWithObjects:values forKeys:keys]];
	
	[keys release];
	[values release];
	
	// Read pref
	
	// Set picker index
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
		view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 260, 32)];
		
		UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 11.0, 10, 10)];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, 0.0, 228, 32)];
		
		[label setBackgroundColor:[UIColor clearColor]];
		[label setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
		
		[view addSubview:image];
		[view addSubview:label];
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
				[image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", @"all"]]];
			} else {
				NSArray *keys = [[labels allKeys] sortedArrayUsingSelector:@selector(compare:)];
				
				[image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [keys objectAtIndex:(row - 1)]]]];
			}
		}
	}
	
	return view;
}

- (IBAction)filter:(id)sender {
	// Read current picker setting
	
	// Filter data
	
	// Store pref
	
	// Refresh views
	[[[UIApplication sharedApplication] delegate] refreshViewData];
}


@end
