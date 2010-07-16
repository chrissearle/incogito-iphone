//
//  DetailedSessionViewController.h
//  incogito
//
//  Created by Markuz Lindgren on 15.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JZSession;
@class SectionSessionHandler;
@class IncogitoAppDelegate;

@interface DetailedSessionViewController : UIViewController {
	JZSession		*session;
	UITextView		*details;
	UILabel			*sessionTitle;
	UILabel			*sessionLocation;
	UILabel			*level;
	UIImageView		*levelImage;
	BOOL			checkboxSelected;
	IBOutlet		UIButton *checkboxButton;
	SectionSessionHandler *handler;
	IBOutlet IncogitoAppDelegate *appDelegate;
}

@property (nonatomic, retain) JZSession		*session;
@property (nonatomic, retain) IBOutlet UITextView	*details;
@property (nonatomic, retain) IBOutlet UILabel		*sessionTitle;
@property (nonatomic, retain) IBOutlet UILabel		*sessionLocation;
@property (nonatomic, retain) IBOutlet UILabel		*level;
@property (nonatomic, retain) IBOutlet UIImageView	*levelImage;
@property (nonatomic, retain) SectionSessionHandler *handler;

- (void) closeModalViewController:(id)sender;
- (NSString *)removeHtmlTags:(NSString *)textWithTags;

- (IBAction)checkboxButton:(id)sender;

@end
