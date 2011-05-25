//
//  ExtrasController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class JZSession;

@interface ExtrasController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	JZSession *session;
    
    NSArray *sections;
    NSDictionary *sectionCells;

    MPMoviePlayerViewController *movie;
}

@property (nonatomic, retain) JZSession *session;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) NSDictionary *sectionCells;
@property (nonatomic,retain) MPMoviePlayerViewController *movie;

- (void)endVideo:(NSNotification*) aNotification;

@end
