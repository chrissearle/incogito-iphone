//
//  FeedbackController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JZSession.h"

@interface FeedbackController : UIViewController <UITextFieldDelegate> {
	JZSession		*session;
	IBOutlet UITextField *emailField;
	IBOutlet UIWebView *formField;
    
    NSURL *feedbackURL;
}

@property (nonatomic, retain) JZSession	  *session;
@property (nonatomic, retain) UITextField *emailField;
@property (nonatomic, retain) UIWebView   *formField;
@property (nonatomic, retain) NSURL *feedbackURL;

@end
