//
//  OverviewViewController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionCommonViewController.h"
#import "MBProgressHUD.h"

@protocol ViewShouldRefreshDelegate
- (void)refeshView:(BOOL)reload withFull:(BOOL)full;
@end

@interface OverviewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate, ViewShouldRefreshDelegate, MBProgressHUDDelegate>

@property (nonatomic, retain) NSString *currentSearch;
@property (nonatomic, retain) IBOutlet UISearchBar *sb;
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

- (void) checkForData;
- (void) search:(NSString *)searchText;
- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar;

- (IBAction) curlPage:(id)sender;
- (IBAction) refresh:(id)sender;
- (IBAction) party:(id)sender;

@end
