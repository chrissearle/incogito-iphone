//
//  SessionCommonViewController.h
//  incogito
//
//  Created by Chris Searle on 17.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncogitoAppDelegate;

@interface SessionCommonViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView			*tv;

	NSArray			*sectionTitles;
	NSDictionary	*sessions;

	IncogitoAppDelegate	*appDelegate;
}

@property (nonatomic, retain) NSArray		*sectionTitles;
@property (nonatomic, retain) NSDictionary	*sessions;

@property (nonatomic, retain) UITableView	*tv;

@property (nonatomic, retain) IncogitoAppDelegate *appDelegate;

- (void)loadSessionData;
- (NSString *)getSelectedSessionTitle:(NSInteger)section;


@end
