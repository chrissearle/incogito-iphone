//
//  JavaZone2011Controller.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface JavaZone2011Controller : UIViewController {
	MPMoviePlayerViewController *movie;
	
	IBOutlet UIView *details;
	
	IBOutlet UIButton *cfpButton;
}

@property (nonatomic,retain) MPMoviePlayerViewController *movie;
@property (nonatomic,retain) UIView *details;
@property (nonatomic,retain) UIButton *cfpButton;

- (void)playVideo:(id)sender;
- (void)endVideo:(NSNotification*) aNotification;
- (void)openCfp:(id)sender;

@end
