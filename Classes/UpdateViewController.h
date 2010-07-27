//
//  UpdateViewController.h
//  incogito
//
//  Created by Chris Searle on 16.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshCommonViewController.h"

@interface UpdateViewController : RefreshCommonViewController  {
	IBOutlet UIButton			*closeButton;
}

- (void) closeModalViewController:(id)sender;

@end
