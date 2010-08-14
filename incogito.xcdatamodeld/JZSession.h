//
//  JZSession.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <CoreData/CoreData.h>

@class JZLabel;
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
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSSet* speakers;
@property (nonatomic, retain) NSSet* labels;
@property (nonatomic, retain) NSManagedObject * userSession;

@end


@interface JZSession (CoreDataGeneratedAccessors)
- (void)addSpeakersObject:(JZSessionBio *)value;
- (void)removeSpeakersObject:(JZSessionBio *)value;
- (void)addSpeakers:(NSSet *)value;
- (void)removeSpeakers:(NSSet *)value;

- (void)addLabelsObject:(JZLabel *)value;
- (void)removeLabelsObject:(JZLabel *)value;
- (void)addLabels:(NSSet *)value;
- (void)removeLabels:(NSSet *)value;

@end

