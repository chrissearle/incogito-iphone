//
//  ExtrasController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"
#import "FeedbackAvailability.h"

@class JZSession;

@interface ExtrasController : UIViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate> {
	JZSession *session;
    
    NSURL *feedbackFormUrl;
    
    NSArray *sections;
    NSDictionary *sectionCells;

    MPMoviePlayerViewController *movie;
    
    MBProgressHUD *HUD;
    
    IBOutlet UITableView *tv;
    
    FeedbackAvailability *feedbackAvailability;
}

@property (nonatomic, retain) JZSession *session;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) NSDictionary *sectionCells;
@property (nonatomic, retain) MPMoviePlayerViewController *movie;
@property (nonatomic, retain) NSURL *feedbackFormUrl;
@property (nonatomic, retain) UITableView *tv;
@property (nonatomic, retain) FeedbackAvailability *feedbackAvailability;

- (void)endVideo:(NSNotification*) aNotification;

@end
