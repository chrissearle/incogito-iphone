//
//  JZLabel.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <CoreData/CoreData.h>

@class JZSession;

@interface JZLabel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * jzId;
@property (nonatomic, retain) JZSession * session;

@end


@interface JZLabel (CoreDataGeneratedAccessors)
@end
