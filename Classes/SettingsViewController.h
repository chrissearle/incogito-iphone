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
    IBOutlet UISwitch *bioPicSwitch;
	IBOutlet UIButton *applyButton;
    IBOutlet UIButton *refreshButton;
    IBOutlet UILabel *labelsLabel;
    IBOutlet UILabel *downloadLabel;
    
	NSDictionary				*labels;
	
	IncogitoAppDelegate *appDelegate;
	
	MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSDictionary						*labels;
@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) UISwitch *bioPicSwitch;
@property (nonatomic, retain) IncogitoAppDelegate *appDelegate;
@property (nonatomic, retain) UIButton *applyButton;
@property (nonatomic, retain) UIButton *refreshButton;
@property (nonatomic, retain) UILabel *labelsLabel;
@property (nonatomic, retain) UILabel *downloadLabel;

- (IBAction)filter:(id)sender;
- (IBAction)sync:(id)sender;
- (IBAction)picSwitch:(id)sender;

- (void)refreshPicker;

- (void)loadData;

@end
