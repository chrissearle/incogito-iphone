//
//  JZSession.h
//  incogito
//
//  Created by Chris Searle on 14.07.10.
//  Copyright 2010 Itera Consulting. All rights reserved.
//

#import <CoreData/CoreData.h>

@class JZSessionBio;

@interface JZSession :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * room;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * jzId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSSet* speakers;
@property (nonatomic, retain) NSString * detail;

@end


@interface JZSession (CoreDataGeneratedAccessors)
- (void)addSpeakersObject:(JZSessionBio *)value;
- (void)removeSpeakersObject:(JZSessionBio *)value;
- (void)addSpeakers:(NSSet *)value;
- (void)removeSpeakers:(NSSet *)value;

@end

