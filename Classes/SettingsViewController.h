//
//  SettingsViewController.h
//  incogito
//
//  Created by Chris Searle on 06.08.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UIPickerView *picker;
	
	NSDictionary				*labels;
}

@property (nonatomic, retain) NSDictionary						*labels;

- (IBAction)filter:(id)sender;

@end
