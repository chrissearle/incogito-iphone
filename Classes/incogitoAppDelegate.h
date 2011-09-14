//
//  incogitoAppDelegate.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class SectionSessionHandler;

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

@property (nonatomic, retain, readonly) SectionSessionHandler *sectionSessionHandler_;

- (NSString *)applicationDocumentsDirectory;
- (SectionSessionHandler *)sectionSessionHandler;

@end

