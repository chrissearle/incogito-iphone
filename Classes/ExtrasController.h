//
//  ExtrasController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JZSession;

@interface ExtrasController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	JZSession		*session;
}

@property (nonatomic, retain) JZSession		*session;

@end
