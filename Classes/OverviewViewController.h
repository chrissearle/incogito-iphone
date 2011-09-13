//
//  OverviewViewController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionCommonViewController.h"

@interface OverviewViewController : SessionCommonViewController <UISearchBarDelegate, UITextFieldDelegate>

@property (nonatomic, retain) NSString *currentSearch;
@property (nonatomic, retain) IBOutlet UISearchBar *sb;

- (void) checkForData;
- (void) search:(NSString *)searchText;
- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar;

- (IBAction) curlPage:(id)sender;
- (IBAction) refresh:(id)sender;
- (IBAction) party:(id)sender;

@end
