//
//  NowAndNextViewController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionCommonViewController.h"

@interface NowAndNextViewController : SessionCommonViewController {
	NSArray *footers;
}

@property (nonatomic, retain) NSArray *footers;

@end
