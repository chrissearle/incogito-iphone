//
//  DetailedSessionViewController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JZSession;
@class SectionSessionHandler;
@class IncogitoAppDelegate;
@class FeedbackAvailability;

@interface DetailedSessionViewController : UIViewController

@property (nonatomic, retain) JZSession		        *session;
@property (nonatomic, retain) IBOutlet UIWebView	*details;
@property (nonatomic, retain) IBOutlet UILabel		*sessionLocation;
@property (nonatomic, retain) IBOutlet UILabel		*level;
@property (nonatomic, retain) IBOutlet UIImageView	*levelImage;
@property (nonatomic, retain) SectionSessionHandler *handler;
@property (nonatomic, retain) IncogitoAppDelegate	*appDelegate;
@property (nonatomic, assign) BOOL                  checkboxSelected;
@property (nonatomic, retain) IBOutlet UIButton     *checkboxButton;
@property (nonatomic, retain) IBOutlet UIButton     *feedbackButton;
@property (nonatomic, retain) IBOutlet UIButton     *videoButton;
@property (nonatomic, retain) IBOutlet UIButton     *shareButton;
@property (nonatomic, retain) FeedbackAvailability  *feedbackAvailability;
@property (nonatomic, retain) NSOperationQueue      *queue;

- (NSString *)buildPage:(NSString *)content withTitle:(NSString *)title withSpeakerInfo:(NSString *)speakerInfo andLabelsInfo:(NSString *)labels;
- (NSString *)buildSpeakersSection:(NSSet *)speakers;
- (NSString *)buildLabelsSection:(NSSet *)labels;

- (IBAction)checkboxButton:(id)sender;

- (IBAction)share:(id)sender;
- (IBAction)feedback:(id)sender;
- (IBAction)video:(id)sender;


- (void)reloadSession;
- (void)displaySession;

- (void)videoCheckComplete;
- (void)feedbackCheckComplete;

@end
