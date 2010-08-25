//
//  JavazoneSessionsRetriever.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

@class RefreshCommonViewController;

@interface JavazoneSessionsRetriever : NSObject {
	NSManagedObjectContext *managedObjectContext;
	RefreshCommonViewController *refreshCommonViewController;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) RefreshCommonViewController *refreshCommonViewController;

- (NSUInteger)retrieveSessions;
- (void) addSession:(NSDictionary *)item;
- (void) invalidateSessions;
- (NSDate *)getDateFromJson:(NSDictionary *)jsonDate;

- (void) removeAllEntitiesByName:(NSString *)entityName;

- (NSString *)getPossibleNilString:(NSString *)key fromDict:(NSDictionary *)dict;

@end
