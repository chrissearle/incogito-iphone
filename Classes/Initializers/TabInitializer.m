//
//  TabInitializer.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "TabInitializer.h"

#ifdef HIDE_OVERVIEW
#import "OverviewViewController.h"
#endif
#ifdef HIDE_FAV
#import "MyProgrammeViewController.h"
#endif
#ifdef HIDE_NOWANDNEXT
#import "NowAndNextViewController.h"
#endif
#ifdef HIDE_CLUBZONE
#import "ClubZoneViewController.h"
#endif
#ifdef HIDE_SETTINGS
#import "SettingsViewController.h"
#endif
#ifdef HIDE_AWEZONE
#import "AweZoneController.h"
#endif


@implementation TabInitializer

@synthesize controllers;

- (TabInitializer *)initWithControllers:(NSArray *)array {
	self = [super init];
	
	if (self) {
		controllers = [NSMutableArray arrayWithArray:array];
	}
	
	return self;
}

- (BOOL)checkObject:(UIViewController *)controller {
	BOOL remove = NO;
	
#ifdef HIDE_CLUBZONE
	if ([controller class] == [ClubZoneViewController class]) {
		NSLog(@"Removing %@", controller);
		
		remove = YES;
	}
#endif
#ifdef HIDE_AWEZONE
	if ([controller class] == [AweZoneController class]) {
		NSLog(@"Removing %@", controller);
		
		remove = YES;
	}
#endif
#ifdef HIDE_SETTINGS
	if ([controller class] == [SettingsViewController class]) {
		NSLog(@"Removing %@", controller);
		
		remove = YES;
	}
#endif
#ifdef HIDE_OVERVIEW
	if ([controller class] == [OverviewViewController class]) {
		NSLog(@"Removing %@", controller);
		
		remove = YES;
	}
#endif
#ifdef HIDE_FAVOURITES
	if ([controller class] == [MyProgrammeViewController class]) {
		NSLog(@"Removing %@", controller);
		
		remove = YES;
	}
#endif
#ifdef HIDE_NOWANDNEXT
	if ([controller class] == [NowAndNextViewController class]) {
		NSLog(@"Removing %@", controller);
		
		remove = YES;
	}
#endif
	
	return remove;
}
					 
- (NSArray *)validControllers {
	NSMutableArray *testControllers = [NSMutableArray arrayWithArray:controllers];
	
	NSEnumerator *enumerator = [controllers objectEnumerator];
	
	id element;
	
	while((element = [enumerator nextObject])) {
		UIViewController *controller = (UIViewController *)element;
		
		if ([element isKindOfClass:[UINavigationController class]]) {
			UINavigationController *navController = (UINavigationController *)element;
			
			controller = [navController.viewControllers objectAtIndex:0];
		}
		
		if ([self checkObject:controller] == YES) {
			[testControllers removeObject:element];
		}
	}
	
	return testControllers;
}

@end

