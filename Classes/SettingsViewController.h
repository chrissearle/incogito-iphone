//
//  SettingsViewController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class IncogitoAppDelegate;

@interface SettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, MBProgressHUDDelegate> {
	IBOutlet UIPickerView *picker;
	
	NSDictionary				*labels;
	
	IncogitoAppDelegate *appDelegate;
	
	MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSDictionary						*labels;
@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) IncogitoAppDelegate *appDelegate;

- (IBAction)filter:(id)sender;
- (IBAction)sync:(id)sender;

- (void)refreshPicker;

- (void)loadData;

@end
