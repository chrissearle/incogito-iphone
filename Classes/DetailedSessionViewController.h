//
//  DetailedSessionViewController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AbstractFeedbackController.h"

@class JZSession;
@class SectionSessionHandler;
@class IncogitoAppDelegate;

@interface DetailedSessionViewController : UIViewController {
	UIWebView		*details;
	UILabel			*sessionLocation;
	UILabel			*level;
	UIImageView		*levelImage;
	BOOL			checkboxSelected;
	IBOutlet		UIButton *checkboxButton;
    JZSession       *session;

	SectionSessionHandler *handler;
	IncogitoAppDelegate *appDelegate;
}

@property (nonatomic, retain) JZSession		*session;
@property (nonatomic, retain) IBOutlet UIWebView	*details;
@property (nonatomic, retain) IBOutlet UILabel		*sessionLocation;
@property (nonatomic, retain) IBOutlet UILabel		*level;
@property (nonatomic, retain) IBOutlet UIImageView	*levelImage;
@property (nonatomic, retain) SectionSessionHandler *handler;
@property (nonatomic, retain) IncogitoAppDelegate	*appDelegate;


- (NSString *)buildPage:(NSString *)content withTitle:(NSString *)title withSpeakerInfo:(NSString *)speakerInfo andLabelsInfo:(NSString *)labels;
- (NSString *)buildSpeakersSection:(NSSet *)speakers;
- (NSString *)buildLabelsSection:(NSSet *)labels;

- (IBAction)checkboxButton:(id)sender;

- (void)reloadSession;
- (void)displaySession;

- (void)showExtras:(id)sender;

@end
