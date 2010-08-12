//
//  SettingsViewController.h
//  incogito
//
//  Created by Chris Searle on 06.08.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncogitoAppDelegate;

@interface SettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UIPickerView *picker;
	
	NSDictionary				*labels;
	
	IncogitoAppDelegate *appDelegate;
}

@property (nonatomic, retain) NSDictionary						*labels;
@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) IncogitoAppDelegate *appDelegate;

- (IBAction)filter:(id)sender;
- (IBAction)sync:(id)sender;

- (void)refreshPicker;

- (void)loadData;

@end
