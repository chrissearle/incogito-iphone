//
//  OverviewViewController.h
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncogitoAppDelegate;

@interface OverviewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet IncogitoAppDelegate		*appDelegate;
	UITableView							*_tableView;
	
	NSArray					*sectionTitles;
	NSDictionary			*sessions;
}

@property (nonatomic, retain) IBOutlet UITableView	*tableView;
@property (nonatomic, retain) NSArray				*sectionTitles;
@property (nonatomic, retain) NSDictionary			*sessions;

@end
