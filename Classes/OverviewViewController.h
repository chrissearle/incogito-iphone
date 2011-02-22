//
//  OverviewViewController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionCommonViewController.h"

@interface OverviewViewController : SessionCommonViewController <UISearchBarDelegate, UITextFieldDelegate> {
	NSString *currentSearch;
	IBOutlet UISearchBar *sb;
}

@property (nonatomic, retain) NSString *currentSearch;
@property (nonatomic, retain) UISearchBar *sb;

- (void) checkForData;
- (void) search:(NSString *)searchText;
- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar;

@end
