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
	IBOutlet IncogitoAppDelegate *appDelegate;
	UIActivityIndicatorView *spinner;
	
	UIAlertView *refreshComplete;
}

- (IBAction)refresh:(id)sender;

@end
