//
//  OverviewViewController.h
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionCommonViewController.h"

@interface OverviewViewController : SessionCommonViewController <UITextFieldDelegate> {
	IBOutlet UITextField *search;
	
	NSString *currentSearch;
	
	BOOL justCleared;
}

@property (nonatomic, retain) UITextField *search;
@property (nonatomic, retain) NSString *currentSearch;

- (void) checkForData;
- (IBAction) search:(id)sender;

@end
