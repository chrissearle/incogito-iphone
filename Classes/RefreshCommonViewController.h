//
//  RefreshCommonViewController.h
//  incogito
//
//  Created by Chris Searle on 27.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncogitoAppDelegate;

@interface RefreshCommonViewController : UIViewController {
	IncogitoAppDelegate			*appDelegate;
	UIActivityIndicatorView		*spinner;
	UITextView					*refreshStatus;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView	*spinner;
@property (nonatomic, retain) IBOutlet UITextView				*refreshStatus;
@property (nonatomic, retain) IncogitoAppDelegate				*appDelegate;

- (void) refreshSessions;
- (void)taskDone:(id)arg;
	

@end
