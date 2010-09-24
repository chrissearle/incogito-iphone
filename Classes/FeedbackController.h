//
//  FeedbackController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class JZSession;

@interface FeedbackController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate> {
	JZSession		*session;
	IBOutlet UITextField *nameField;
	IBOutlet UITextField *emailField;
	IBOutlet UITextView *commentField;
	
	IBOutlet UIButton *ratingButton1;
	IBOutlet UIButton *ratingButton2;
	IBOutlet UIButton *ratingButton3;
	IBOutlet UIButton *ratingButton4;
	IBOutlet UIButton *ratingButton5;
	
	IBOutlet UIScrollView *scrollView;
	
	BOOL clearView;
}

@property (nonatomic, retain) JZSession		*session;
@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *emailField;
@property (nonatomic, retain) UITextView *commentField;

@property (nonatomic, retain) UIButton *ratingButton1;
@property (nonatomic, retain) UIButton *ratingButton2;
@property (nonatomic, retain) UIButton *ratingButton3;
@property (nonatomic, retain) UIButton *ratingButton4;
@property (nonatomic, retain) UIButton *ratingButton5;

@property (nonatomic, retain) UIScrollView *scrollView;

- (void)send:(id) sender;
- (void)ratingButtonClicked:(id)sender;

@end
