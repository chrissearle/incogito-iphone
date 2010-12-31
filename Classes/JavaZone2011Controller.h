//
//  JavaZone2011Controller.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface JavaZone2011Controller : UIViewController {
	MPMoviePlayerViewController *movie;
}

@property (nonatomic,retain) MPMoviePlayerViewController *movie;

- (void)playVideo:(id)sender;
- (void)endVideo:(NSNotification*) aNotification;

@end
