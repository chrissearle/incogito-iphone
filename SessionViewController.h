//
//  sessionViewController.h
//  incogito
//
//  Created by Chris Searle on 13.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	NSManagedObjectContext *managedObjectContext;
    NSMutableArray *sessionsArray;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *sessionsArray;

@end
