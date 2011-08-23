//
//  ClearDataInitializer.h
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SectionSessionHandler.h"

@interface ClearDataInitializer : NSObject

@property (nonatomic, retain) NSArray *activeYears;
@property (nonatomic, retain) SectionSessionHandler *handler;

- (id)initWithSectionSessionHandler:(SectionSessionHandler *) handler;

- (void)clearOldSections;
- (void)clearOldSessions;

@end
