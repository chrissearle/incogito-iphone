//
//  FilterViewController.h
//  incogito
//
//  Created by Chris Searle on 13.09.11.
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncogitoAppDelegate;

@interface FilterViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) NSDictionary *labels;
@property (nonatomic, retain) IBOutlet UISegmentedControl *listSelector;
@property (nonatomic, retain) IBOutlet UISegmentedControl *levelSelector;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IncogitoAppDelegate *appDelegate;

- (IBAction) done:(id)selector;

@end
