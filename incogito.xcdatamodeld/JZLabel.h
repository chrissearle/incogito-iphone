//
//  JZLabel.h
//  incogito
//
//  Created by Chris Searle on 15.07.10.
//  Copyright 2010 Itera Consulting. All rights reserved.
//

#import <CoreData/CoreData.h>

@class JZSession;

@interface JZLabel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * jzId;
@property (nonatomic, retain) NSSet* session;

@end


@interface JZLabel (CoreDataGeneratedAccessors)
- (void)addSessionObject:(JZSession *)value;
- (void)removeSessionObject:(JZSession *)value;
- (void)addSession:(NSSet *)value;
- (void)removeSession:(NSSet *)value;

@end

