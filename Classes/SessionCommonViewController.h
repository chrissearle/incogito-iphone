//
//  SessionCommonViewController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class IncogitoAppDelegate;

@interface SessionCommonViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, retain) NSArray		*sectionTitles;
@property (nonatomic, retain) NSDictionary	*sessions;
@property (nonatomic, retain) IBOutlet UITableView	*tv;
@property (nonatomic, retain) IncogitoAppDelegate *appDelegate;
@property (nonatomic, retain) NSDate *lastSuccessfulUpdate;
@property (nonatomic, retain) MBProgressHUD *HUD;

- (void)loadSessionData;
- (NSString *)getSelectedSessionTitle:(NSInteger)section;

- (IBAction)toggleFavourite:(id)sender;

- (void)sync;

@end
