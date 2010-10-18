//
//  SessionTableViewCell.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionTableViewCell : UITableViewCell {
	IBOutlet UIImageView *favouriteImage;
	IBOutlet UIImageView *levelImage;
	
	IBOutlet UILabel *sessionLabel;
	IBOutlet UILabel *speakerLabel;
	
	IBOutlet UIView *iconBarView;
}

@property (nonatomic, retain) UIImageView *favouriteImage;
@property (nonatomic, retain) UIImageView *levelImage;

@property (nonatomic, retain) UILabel *sessionLabel;
@property (nonatomic, retain) UILabel *speakerLabel;

@property (nonatomic, retain) UIView *iconBarView;

@end
