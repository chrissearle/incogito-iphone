//
//  FeedbackController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JZSession.h"

@interface FeedbackController : UIViewController <UITextFieldDelegate, UIWebViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) JZSession	  *session;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UIWebView   *formField;
@property (nonatomic, retain) NSURL *feedbackURL;

@end
