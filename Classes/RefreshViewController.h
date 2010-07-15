//
//  RefreshViewController.h
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IncogitoAppDelegate;


@interface RefreshViewController : UIViewController {
	IncogitoAppDelegate			*appDelegate;
	UIActivityIndicatorView		*spinner;
	UITextView					*refreshStatus;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView	*spinner;
@property (nonatomic, retain) IBOutlet UITextView				*refreshStatus;

- (IBAction)refresh:(id)sender;

@end
