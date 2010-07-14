//
//  incogitoAppDelegate.m
//  incogito
//
//  Created by Chris Searle on 09.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "IncogitoAppDelegate.h"
#import "JavazoneSessionsRetriever.h"
#import "JZSession.h"

@implementation IncogitoAppDelegate

@synthesize window;
@synthesize rootController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	[window addSubview:rootController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    
    NSError *error = nil;
    if (managedObjectContext_ != nil) {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"incogito" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"incogito.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
    [window release];
	[rootController release]; 
    [super dealloc];
}

#pragma mark -
#pragma mark REST 

- (NSUInteger)refreshData {
	JavazoneSessionsRetriever *retriever = [[[JavazoneSessionsRetriever alloc] init] autorelease];
	
	retriever.managedObjectContext = [self managedObjectContext];
	
	return [retriever retrieveSessionsWithUrl:@"http://javazone.no/incogito10/rest/events/JavaZone%202010/sessions"];
}

#pragma mark -
#pragma mark Data retrieval utils

- (NSArray *)getSectionTitles {
	return [NSArray arrayWithObjects:@"Day 1: 09:00 - 10:00",
			@"Day 1: 10:15 - 11:15", 
			@"Day 1: 11:45 - 12:45", 
			@"Day 1: 13:00 - 14:00", 
			@"Day 1: 14:15 - 15:15", 
			@"Day 1: 15:45 - 16:45", 
			@"Day 1: 17:00 - 18:00", 
			@"Day 1: 18:15 - 19:15", 
			@"Day 2: 09:00 - 10:00", 
			@"Day 2: 10:15 - 11:15", 
			@"Day 2: 11:45 - 12:45", 
			@"Day 2: 13:00 - 14:00", 
			@"Day 2: 14:15 - 15:15", 
			@"Day 2: 15:45 - 16:45", 
			@"Day 2: 17:00 - 18:00", 
			nil];
}

- (NSDictionary *)getSessions {
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:context];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	
	[request setEntity:entityDescription];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"room" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
		
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(active == %@)", [NSNumber numberWithBool:true]];
	
	[request setPredicate:predicate];

	NSError *error;
	
	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
	
	NSArray *sessionsArray = [[NSArray alloc] initWithArray:mutableFetchResults];
	
	NSArray *keys = [NSArray arrayWithObjects:@"Day 1: 09:00 - 10:00", nil];
	NSArray *objects = [NSArray arrayWithObjects:sessionsArray, nil];
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	[mutableFetchResults release];
	[request release];
	
	return dictionary;
}


@end

