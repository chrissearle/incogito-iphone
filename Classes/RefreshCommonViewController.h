//
//  RefreshCommonViewController.h
//  incogito
//
//  Created by Chris Searle on 27.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class IncogitoAppDelegate;

@interface RefreshCommonViewController : UIViewController {
	IncogitoAppDelegate			*appDelegate;
	UIActivityIndicatorView		*spinner;
	UITextView					*refreshStatus;
	UIProgressView				*progressView;
	IBOutlet UIButton			*closeButton;
	IBOutlet UIView				*greyView;
	IBOutlet UILabel			*firstTimeText;
	BOOL						hideFirstTimeText;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView	*spinner;
@property (nonatomic, retain) IBOutlet UITextView				*refreshStatus;
@property (nonatomic, retain) IncogitoAppDelegate				*appDelegate;
@property (nonatomic, retain) IBOutlet UIProgressView			*progressView;
@property (nonatomic, retain) UILabel							*firstTimeText;

- (void) refreshSessions;
- (void)taskDone:(id)arg;

- (void)showProgressBar:(id)arg;
- (void)setProgressTo:(id)progress;
	
- (void) closeModalViewController:(id)sender;
- (void) setFirstTimeTextVisibility:(BOOL) visibility;

@end
