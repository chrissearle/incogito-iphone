//
//  JZSessionBio.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <CoreData/CoreData.h>

@class JZSession;

@interface JZSessionBio :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) JZSession * session;

@end



