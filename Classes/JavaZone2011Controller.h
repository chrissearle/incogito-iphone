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
}

@property (nonatomic,retain) MPMoviePlayerViewController *movie;
@property (nonatomic,retain) UIView *details;

- (void)playVideo:(id)sender;
- (void)endVideo:(NSNotification*) aNotification;

@end
