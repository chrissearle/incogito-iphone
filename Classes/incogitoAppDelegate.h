//
//  incogitoAppDelegate.h
//  incogito
//
//  Created by Chris Searle on 09.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface IncogitoAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	IBOutlet UITabBarController *rootController;
	
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

- (NSUInteger)refreshData;

- (NSArray *)getSectionTitles;
- (NSDictionary *)getSessions;

- (BOOL)startDate:(NSDate *)startDate andEndDate:(NSDate *)endDate areBetween:(NSDate *)earliestDate and:(NSDate *)latestDate;

@end

