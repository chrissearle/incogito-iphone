//
//  SettingsViewController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class IncogitoAppDelegate;

@interface SettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, MBProgressHUDDelegate>

@property (nonatomic, retain) NSDictionary *labels;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UISwitch *bioPicSwitch;
@property (nonatomic, retain) IncogitoAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UIButton *applyButton;
@property (nonatomic, retain) IBOutlet UIButton *refreshButton;
@property (nonatomic, retain) IBOutlet UILabel *labelsLabel;
@property (nonatomic, retain) IBOutlet UILabel *downloadLabel;
@property (nonatomic, retain) NSDate *lastSuccessfulUpdate;
@property (nonatomic, retain) MBProgressHUD *HUD;

- (IBAction)filter:(id)sender;
- (IBAction)sync:(id)sender;
- (IBAction)picSwitch:(id)sender;

- (void)refreshPicker;

- (void)loadData;

@end
