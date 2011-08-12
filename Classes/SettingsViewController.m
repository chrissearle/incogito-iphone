//
//  SettingsViewController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SettingsViewController.h"
#import "IncogitoAppDelegate.h"
#import "SectionSessionHandler.h"
#import "FlurryAPI.h"

#import "JavazoneSessionsRetriever.h"
#import "JavaZonePrefs.h"

@implementation SettingsViewController

@synthesize labels;
@synthesize picker;
@synthesize appDelegate;
@synthesize bioPicSwitch;
@synthesize applyButton;
@synthesize refreshButton;
@synthesize labelsLabel;
@synthesize downloadLabel;
@synthesize lastSuccessfulUpdate;

- (void)redrawForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        if (UIDeviceOrientationIsLandscape(interfaceOrientation)) {
            picker.frame = CGRectMake(0, 55, 250, 216);
            labelsLabel.frame = CGRectMake(7, 20, 280, 34);
            applyButton.frame = CGRectMake(258, 55, 202, 37);
            refreshButton.frame = CGRectMake(258, 150, 202, 37);
            downloadLabel.frame = CGRectMake(258, 195, 267, 21);
            bioPicSwitch.frame = CGRectMake(366, 224, 94, 27);
        } else {
            picker.frame = CGRectMake(0, 62, 320, 216);
            labelsLabel.frame = CGRectMake(20, 20, 280, 34);
            applyButton.frame = CGRectMake(20, 286, 280, 37);
            refreshButton.frame = CGRectMake(20, 331, 280, 37);
            downloadLabel.frame = CGRectMake(20, 379, 178, 24);
            bioPicSwitch.frame = CGRectMake(206, 376, 94, 27);
        }
    } else {
        CGSize frameSize = self.view.frame.size;
        
        int mainWidth = 320;
        int mainLeft = (frameSize.width - mainWidth) / 2;
        
        
        int mainTop = (frameSize.height - 409) / 2;
        int refreshTop = mainTop + 325;
        
        picker.frame = CGRectMake(mainLeft, mainTop, mainWidth, 216);
        applyButton.frame = CGRectMake(mainLeft, mainTop + 224, mainWidth, 37);
        refreshButton.frame = CGRectMake(mainLeft, refreshTop, mainWidth, 37);
        downloadLabel.frame = CGRectMake(mainLeft, refreshTop + 60, mainWidth - 100, 24);
        bioPicSwitch.frame = CGRectMake(mainLeft + mainWidth - 94, refreshTop + 57, 94, 27);
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setAppDelegate:[[UIApplication sharedApplication] delegate]];

	[self loadData];
}

- (void) viewWillAppear:(BOOL)animated {
	[FlurryAPI logEvent:@"Showing Settings"];
    
    [self redrawForOrientation:[self interfaceOrientation]];
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
		view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 230, 32)] autorelease];
		
		UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 11.0, 10, 10)];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, 0.0, 198, 32)];
		
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
				
				NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
				
				NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:@"labelIcons"],[keys objectAtIndex:(row - 1)]];
				
				NSData *data1 = [NSData dataWithContentsOfFile:pngFilePath];

				UIImage *imageFile;
				
				if (nil == data1) {
					NSLog(@"File not found %@", pngFilePath);
					
					imageFile = [UIImage imageNamed:@"all.png"];
				} else {
					imageFile = [UIImage imageWithData:data1];
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

	[FlurryAPI logEvent:@"Filtered" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															   message,
															   @"Message",
															   nil]];
	
	
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
    [self setLastSuccessfulUpdate:[JavaZonePrefs lastSuccessfulUpdate]];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];

	JavazoneSessionsRetriever *retriever = [[[JavazoneSessionsRetriever alloc] init] autorelease];
	
	retriever.managedObjectContext = [appDelegate managedObjectContext];
	retriever.HUD = HUD;
	
	retriever.urlString = [JavaZonePrefs sessionUrl];
	
    // Add HUD to screen
    [self.tabBarController.view addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Preparing";
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(retrieveSessions:) onTarget:retriever withObject:nil animated:YES];
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

    [bioPicSwitch setOn:[JavaZonePrefs showBioPic] animated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];

    
    if (abs([[self lastSuccessfulUpdate] timeIntervalSinceDate:[JavaZonePrefs lastSuccessfulUpdate]]) < 2) {
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Download failed"
							  message: @"Sessions unavailable - please try again later"
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
        
        return;
    }
    
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];
	
	NSUInteger count = [handler getActiveSessionCount];
	
	if (count == 0) {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Download failed"
							  message: @"Unable to download sessions - check your connection and try again"
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	} else {
		[appDelegate refreshViewData];
		[self loadData];
	}
}

- (IBAction)picSwitch:(id)sender {
    [JavaZonePrefs setShowBioPic:bioPicSwitch.on];
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                         duration:(NSTimeInterval)duration {

    [self redrawForOrientation:toInterfaceOrientation];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
