@class RefreshCommonViewController;

@interface JavazoneSessionsRetriever : NSObject {
	NSManagedObjectContext *managedObjectContext;
	RefreshCommonViewController *refreshCommonViewController;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) RefreshCommonViewController *refreshCommonViewController;

- (NSUInteger)retrieveSessionsWithUrl:(NSString *)urlString;
- (void) addSession:(NSDictionary *)item;
- (void) invalidateSessions;
- (NSDate *)getDateFromJson:(NSDictionary *)jsonDate;

- (void) removeAllEntitiesByName:(NSString *)entityName;

@end
