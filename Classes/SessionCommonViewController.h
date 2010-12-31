//
//  SessionCommonViewController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class IncogitoAppDelegate;

@interface SessionCommonViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
	IBOutlet UITableView			*tv;

	NSArray			*sectionTitles;
	NSDictionary	*sessions;

	IncogitoAppDelegate	*appDelegate;
	
	MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSArray		*sectionTitles;
@property (nonatomic, retain) NSDictionary	*sessions;

@property (nonatomic, retain) UITableView	*tv;

@property (nonatomic, retain) IncogitoAppDelegate *appDelegate;

- (void)loadSessionData;
- (NSString *)getSelectedSessionTitle:(NSInteger)section;

- (IBAction)toggleFavourite:(id)sender;

- (void)sync;

@end
