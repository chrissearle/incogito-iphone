//
//  JavazoneSessionsRetriever.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "MBProgressHUD.h"

@interface JavazoneSessionsRetriever : NSObject {
	NSManagedObjectContext *managedObjectContext;
	NSObject *callingView;
	MBProgressHUD *HUD;
	
	NSString *urlString;
	
	NSMutableDictionary *labelUrls;
	NSMutableDictionary *levelUrls;
	
	NSString *labelsPath;
	NSString *levelsPath;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *urlString;

@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) NSMutableDictionary *labelUrls;
@property (nonatomic, retain) NSMutableDictionary *levelUrls;

@property (nonatomic, retain) NSString *levelsPath;
@property (nonatomic, retain) NSString *labelsPath;

- (NSUInteger)retrieveSessions:(id)sender;

- (void) addSession:(NSDictionary *)item;
- (void) invalidateSessions;
- (NSDate *)getDateFromJson:(NSDictionary *)jsonDate;

- (void) removeAllEntitiesByName:(NSString *)entityName;

- (NSString *)getPossibleNilString:(NSString *)key fromDict:(NSDictionary *)dict;

- (void)downloadIconFromUrl:(NSString *)url withName:(NSString *)name toFolder:(NSString *)folder;

@end
