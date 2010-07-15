//
//  NowAndNextViewController.h
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncogitoAppDelegate;

@interface NowAndNextViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet IncogitoAppDelegate	*appDelegate;
	UITableView						*_tableView;

	NSArray				*sectionTitles;
	NSDictionary		*sessions;
	NSString			*sectionName;
	NSArray				*sectionSessions;
}

@property (nonatomic, retain) IBOutlet UITableView	*tableView;
@property (nonatomic, retain) NSArray				*sectionTitles;
@property (nonatomic, retain) NSDictionary			*sessions;
@property (nonatomic, retain) NSArray				*sectionSessions;

@end
