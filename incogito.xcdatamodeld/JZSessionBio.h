//
//  JZSessionBio.h
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Itera Consulting. All rights reserved.
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



