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
@property (nonatomic, retain) JZSession * session;

@end


@interface JZLabel (CoreDataGeneratedAccessors)
@end
