//
//  SectionSessionHandler.h
//  incogito
//
//  Created by Chris Searle on 15.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionSessionHandler : NSObject {
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (NSArray *)getSectionTitles;

@end
