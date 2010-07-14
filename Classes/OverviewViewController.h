//
//  OverviewViewController.h
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncogitoAppDelegate;

@interface OverviewViewController : UIViewController <UITableViewDataSource> {
	IBOutlet IncogitoAppDelegate *appDelegate;
	
	NSMutableArray *sectionTitles;
}

@property (nonatomic, retain) NSMutableArray *sectionTitles;

@end
