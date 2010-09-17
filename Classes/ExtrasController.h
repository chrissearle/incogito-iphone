//
//  ExtrasController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JZSession;

@interface ExtrasController : UIViewController {
	IBOutlet UIButton *shareButton;
	IBOutlet UIButton *sharePicButton;
	IBOutlet UIButton *shareLinkButton;
	JZSession		*session;
}

@property (nonatomic,retain) UIButton *shareButton;
@property (nonatomic,retain) UIButton *shareLinkButton;
@property (nonatomic,retain) UIButton *sharePicButton;
@property (nonatomic, retain) JZSession		*session;

- (void)share:(id)sender;
- (void)shareLink:(id)sender;

@end
