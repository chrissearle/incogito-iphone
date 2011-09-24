//
//  FilterViewController.h
//  incogito
//
//  Created by Chris Searle on 13.09.11.
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionViewController.h"

@class IncogitoAppDelegate;

@interface FilterViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) id<ViewShouldRefreshDelegate> viewShouldRefreshDelegate;

@property (nonatomic, retain) NSDictionary *labels;

@property (nonatomic, retain) IBOutlet UISegmentedControl *listSelector;
@property (nonatomic, retain) IBOutlet UISegmentedControl *levelSelector;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UILabel *listLabel;
@property (nonatomic, retain) IBOutlet UILabel *levelLabel;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IncogitoAppDelegate *appDelegate;
@property (nonatomic, assign) BOOL initialized;

- (IBAction) done:(id)sender;
- (IBAction) listSelected:(id)selector;
- (IBAction) levelSelected:(id)selector;

@end
