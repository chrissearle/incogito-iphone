//
//  OverviewViewController.h
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OverviewViewController : UIViewController {
	IBOutlet UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
