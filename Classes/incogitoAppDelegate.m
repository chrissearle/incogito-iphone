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
#import "SectionInitializer.h"
#import "Section.h"
#import "SectionSessionHandler.h"

@implementation IncogitoAppDelegate

@synthesize window;
@synthesize rootController;
@synthesize sectionSessionHandler;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Start of application:didFinishLaunchingWithOptions", [[[NSDate alloc] init] autorelease]);
#endif

#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Calling sectionInitializer", [[[NSDate alloc] init] autorelease]);
#endif
	
	SectionInitializer *sectionInitializer = [[SectionInitializer alloc] init];
	[sectionInitializer setManagedObjectContext:[self managedObjectContext]];
	[sectionInitializer initializeSections];
	[sectionInitializer release];

#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Called sectionInitializer", [[[NSDate alloc] init] autorelease]);
#endif
	
	
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

			UIAlertView *errorAlert = [[UIAlertView alloc]
									   initWithTitle: @"Unable to save data state to the data store at shutdown"
									   message: @"This is not an error we can recover from - please exit using the home button."
									   delegate:nil
									   cancelButtonTitle:@"OK"
									   otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];

			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
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
    
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ No moc - initializing", [[[NSDate alloc] init] autorelease]);
#endif
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
	}

#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ No moc - initialized", [[[NSDate alloc] init] autorelease]);
#endif
	
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

#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ No mom - initializing", [[[NSDate alloc] init] autorelease]);
#endif
	
	NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"incogito" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    

#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ No mom - initialized", [[[NSDate alloc] init] autorelease]);
#endif
	
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
    
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ No persistent store - initializing", [[[NSDate alloc] init] autorelease]);
#endif
	
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"incogito.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		
		UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle: @"Unable to load data store"
								   message: @"The data store failed to load and without it this application has no data to show. This is not an error we can recover from - please exit using the home button."
								   delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
		
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }    
    
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ No persistent store - initialized", [[[NSDate alloc] init] autorelease]);
#endif

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
	[sectionSessionHandler_ release];
    
    [window release];
	[rootController release]; 
    [super dealloc];
}

- (SectionSessionHandler *)sectionSessionHandler {
	if (sectionSessionHandler_ != nil) {
        return sectionSessionHandler_;
    }
    
	sectionSessionHandler_ = [[SectionSessionHandler alloc] init];
	
	[sectionSessionHandler_ setManagedObjectContext:[self managedObjectContext]];
	
	return sectionSessionHandler_;
}

@end

