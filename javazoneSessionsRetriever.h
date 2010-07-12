@interface javazoneSessionsRetriever : NSObject {
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)retrieveSessionsWithUrl:(NSString *)urlString;
- (void) addSession:(NSDictionary *)item;
- (void) invalidateSessions;


@end
