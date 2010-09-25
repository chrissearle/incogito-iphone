//
//  JavazoneSessionsRetriever.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

@class RefreshCommonViewController;

@interface JavazoneSessionsRetriever : NSObject {
	NSManagedObjectContext *managedObjectContext;
	RefreshCommonViewController *refreshCommonViewController;
	
	NSMutableDictionary *labelUrls;
	NSMutableDictionary *levelUrls;
	
	NSString *labelsPath;
	NSString *levelsPath;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) RefreshCommonViewController *refreshCommonViewController;
@property (nonatomic, retain) NSMutableDictionary *labelUrls;
@property (nonatomic, retain) NSMutableDictionary *levelUrls;

@property (nonatomic, retain) NSString *levelsPath;
@property (nonatomic, retain) NSString *labelsPath;

- (NSUInteger)retrieveSessions:(NSString *)urlString;
- (void) addSession:(NSDictionary *)item;
- (void) invalidateSessions;
- (NSDate *)getDateFromJson:(NSDictionary *)jsonDate;

- (void) removeAllEntitiesByName:(NSString *)entityName;

- (NSString *)getPossibleNilString:(NSString *)key fromDict:(NSDictionary *)dict;

- (void)downloadIconFromUrl:(NSString *)url withName:(NSString *)name toFolder:(NSString *)folder;

@end
