//
//  UITabBarController+Autorotate.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "UITabBarController+Autorotate.h"

@implementation UITabBarController (Autorotate)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    UIViewController *controller = self.selectedViewController;
    if ([controller isKindOfClass:[UINavigationController class]])
        controller = [(UINavigationController *)controller visibleViewController];
    return [controller shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
