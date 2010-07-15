//
//  NowAndNextViewController.h
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncogitoAppDelegate;

@interface NowAndNextViewController : UIViewController <UITableViewDataSource> {
	IBOutlet IncogitoAppDelegate *appDelegate;

	NSArray *sectionTitles;
	NSDictionary *sessions;
}

@property (nonatomic, retain) NSArray *sectionTitles;
@property (nonatomic, retain) NSDictionary *sessions;

- (void)reloadSessionData;

@end
