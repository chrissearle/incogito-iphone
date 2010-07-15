@interface JavazoneSessionsRetriever : NSObject {
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (NSUInteger)retrieveSessionsWithUrl:(NSString *)urlString;
- (void) addSession:(NSDictionary *)item;
- (void) invalidateSessions;
- (NSDate *)getDateFromJson:(NSDictionary *)jsonDate;

- (void) removeAllEntitiesByName:(NSString *)entityName;

@end
