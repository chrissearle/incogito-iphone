//
//  JZSession.h
//  incogito
//
//  Created by Chris Searle on 12.07.10.
//  Copyright 2010 Itera Consulting. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface JZSession :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * jzId;
@property (nonatomic, retain) NSNumber * active;

@end



