//
//  SettingsViewController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SettingsViewController.h"
#import "IncogitoAppDelegate.h"
#import "SectionSessionHandler.h"

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
@synthesize HUD;

- (void)redrawForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        if (UIDeviceOrientationIsLandscape(interfaceOrientation)) {
            self.picker.frame = CGRectMake(0, 55, 250, 216);
            self.labelsLabel.frame = CGRectMake(7, 20, 280, 34);
            self.applyButton.frame = CGRectMake(258, 55, 202, 37);
            self.refreshButton.frame = CGRectMake(258, 150, 202, 37);
            self.downloadLabel.frame = CGRectMake(258, 195, 267, 21);
            self.bioPicSwitch.frame = CGRectMake(366, 224, 94, 27);
        } else {
            self.picker.frame = CGRectMake(0, 62, 320, 216);
            self.labelsLabel.frame = CGRectMake(20, 20, 280, 34);
            self.applyButton.frame = CGRectMake(20, 286, 280, 37);
            self.refreshButton.frame = CGRectMake(20, 331, 280, 37);
            self.downloadLabel.frame = CGRectMake(20, 379, 178, 24);
            self.bioPicSwitch.frame = CGRectMake(206, 376, 94, 27);
        }
    } else {
        CGSize frameSize = self.view.frame.size;
        
        int mainWidth = 320;
        int mainLeft = (frameSize.width - mainWidth) / 2;
        
        
        int mainTop = (frameSize.height - 409) / 2;
        int refreshTop = mainTop + 325;
        
        self.picker.frame = CGRectMake(mainLeft, mainTop, mainWidth, 216);
        self.applyButton.frame = CGRectMake(mainLeft, mainTop + 224, mainWidth, 37);
        self.refreshButton.frame = CGRectMake(mainLeft, refreshTop, mainWidth, 37);
        self.downloadLabel.frame = CGRectMake(mainLeft, refreshTop + 60, mainWidth - 100, 24);
        self.bioPicSwitch.frame = CGRectMake(mainLeft + mainWidth - 94, refreshTop + 57, 94, 27);
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.appDelegate = [[UIApplication sharedApplication] delegate];

	[self loadData];
}

- (void) viewWillAppear:(BOOL)animated {
	[FlurryAnalytics logEvent:@"Showing Settings"];
    
    [self redrawForOrientation:[self interfaceOrientation]];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.picker = nil;
    self.bioPicSwitch = nil;
    self.applyButton = nil;
    self.refreshButton = nil;
    self.labelsLabel = nil;
    self.downloadLabel = nil;
    
    self.appDelegate = nil;
}

- (void)dealloc {
	[labels release];
    [picker release];
    [appDelegate release];
    [bioPicSwitch release];
    [applyButton release];
    [refreshButton release];
    [labelsLabel release];
    [downloadLabel release];
    [lastSuccessfulUpdate release];
    [HUD release];
	
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
				NSArray *keys = [[self.labels allKeys] sortedArrayUsingSelector:@selector(compare:)];
				[label setText:[self.labels objectForKey:[keys objectAtIndex:(row - 1)]]];
			}
		}
		
		if ([subview class] == [UIImageView class]) {
			UIImageView *image = (UIImageView *)subview;
			if (row == 0) {
				[image setImage:[UIImage imageNamed:@"all.png"]];
			} else {
				NSArray *keys = [[self.labels allKeys] sortedArrayUsingSelector:@selector(compare:)];
				
				NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
				
				NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:@"labelIcons"],[keys objectAtIndex:(row - 1)]];
				
				NSData *data1 = [NSData dataWithContentsOfFile:pngFilePath];

				UIImage *imageFile;
				
				if (nil == data1) {
					AppLog(@"File not found %@", pngFilePath);
					
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
	NSArray *values = [[self.labels allValues] sortedArrayUsingSelector:@selector(compare:)];
	
	int index = [self.picker selectedRowInComponent:0];
	
	NSString *label = @"All";
	
	NSString *messageTitle = @"Session filter cleared";
	NSString *message = @"Showing all sessions.";
	
	if (index > 0) {
		label = [values objectAtIndex:(index - 1)];

		messageTitle = @"Session filter applied";
		message = [NSString stringWithFormat:@"Showing only %@. This setting will be remembered - if you can't see sessions you expect to see - remember to check back here.", label];
	}

	// Store pref
	[self.appDelegate setLabelFilter:label];
	
	// Refresh views
	[self.appDelegate refreshViewData];

	[FlurryAnalytics logEvent:@"Filtered" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
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
    
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.tabBarController.view] autorelease];

	JavazoneSessionsRetriever *retriever = [[[JavazoneSessionsRetriever alloc] init] autorelease];
	
	retriever.managedObjectContext = [self.appDelegate managedObjectContext];
	retriever.HUD = self.HUD;
	
	retriever.urlString = [JavaZonePrefs sessionUrl];
	
    // Add HUD to screen
    [self.tabBarController.view addSubview:self.HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    self.HUD.delegate = self;
	
    self.HUD.labelText = @"Preparing";
	
    // Show the HUD while the provided method executes in a new thread
    [self.HUD showWhileExecuting:@selector(retrieveSessions:) onTarget:retriever withObject:nil animated:YES];
}

- (void)refreshPicker {
	[self loadData];

	[self.picker reloadAllComponents];
}

- (void)loadData {
	[self setLabels:[[self.appDelegate sectionSessionHandler] getUniqueLabels]];
	
	// Set picker index
	NSString *savedKey = [self.appDelegate getLabelFilter];
	
	NSArray *values = [[self.labels allValues] sortedArrayUsingSelector:@selector(compare:)];
	
	int index = 0;
	if ([values containsObject:savedKey]) {
		NSArray *sortedValues = [values sortedArrayUsingSelector:@selector(compare:)];
		index = [sortedValues indexOfObject:savedKey] + 1;
	}
	[self.picker selectRow:index inComponent:0 animated:YES];

    [self.bioPicSwitch setOn:[JavaZonePrefs showBioPic] animated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [self.HUD removeFromSuperview];
    
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
    
	SectionSessionHandler *handler = [self.appDelegate sectionSessionHandler];
	
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
		[self.appDelegate refreshViewData];
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
