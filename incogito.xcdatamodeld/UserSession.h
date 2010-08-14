//
//  UserSession.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <CoreData/CoreData.h>

@class JZSession;

@interface UserSession :  NSManagedObject  
{
}

@property (nonatomic, retain) JZSession * session;

@end



