//
//  UpdateViewController.h
//  incogito
//
//  Created by Chris Searle on 16.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncogitoAppDelegate;


@interface UpdateViewController : UIViewController  {
	IncogitoAppDelegate			*appDelegate;
	UIActivityIndicatorView		*spinner;
	UITextView					*refreshStatus;
	IBOutlet UIButton			*closeButton;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView	*spinner;
@property (nonatomic, retain) IBOutlet UITextView				*refreshStatus;
@property (nonatomic, retain) IncogitoAppDelegate				*appDelegate;

- (void) closeModalViewController:(id)sender;

@end
