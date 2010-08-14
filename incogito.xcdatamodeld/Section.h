//
//  Section.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Section :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;

@end



