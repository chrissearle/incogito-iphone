//
//  TabInitializer.h
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabInitializer : NSObject {
	NSArray *controllers;
}

@property (nonatomic, retain) NSArray *controllers;

- (TabInitializer *)initWithControllers:(NSArray *)array;

- (NSArray *)validControllers;

@end
