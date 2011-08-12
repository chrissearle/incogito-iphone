//
//  SessionTableViewCell.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionTableViewCell : UITableViewCell {
	IBOutlet UIButton *favouriteImage;
	IBOutlet UIImageView *levelImage;
	
	IBOutlet UILabel *sessionLabel;
	IBOutlet UILabel *speakerLabel;
	
	IBOutlet UIView *iconBarView;
	
	NSString *jzId;
}

@property (nonatomic, retain) UIButton *favouriteImage;
@property (nonatomic, retain) UIImageView *levelImage;

@property (nonatomic, retain) UILabel *sessionLabel;
@property (nonatomic, retain) UILabel *speakerLabel;

@property (nonatomic, retain) UIView *iconBarView;

@property (nonatomic, retain) NSString *jzId;

@end
