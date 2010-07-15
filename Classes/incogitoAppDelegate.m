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
	SectionInitializer *sectionInitializer = [[SectionInitializer alloc] init];
	[sectionInitializer setManagedObjectContext:[self managedObjectContext]];
	[sectionInitializer initializeSections];
	[sectionInitializer release];
	
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
	[sectionSessionHandler_ release];
    
    [window release];
	[rootController release]; 
    [super dealloc];
}

#pragma mark -
#pragma mark REST 

- (NSUInteger)refreshData {
	JavazoneSessionsRetriever *retriever = [[[JavazoneSessionsRetriever alloc] init] autorelease];
	
	retriever.managedObjectContext = [self managedObjectContext];
	
	NSUInteger count = [retriever retrieveSessionsWithUrl:@"http://javazone.no/incogito10/rest/events/JavaZone%202010/sessions"];
	
	NSArray *controllers = [rootController viewControllers];
	
	for (UIViewController *controller in controllers) {
		if ([controller respondsToSelector:@selector(reloadSessionData)]) {
			[controller reloadSessionData];
		}
	}
	
	return count;
}

#pragma mark -
#pragma mark Data retrieval utils

- (NSDictionary *)getSessions {
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:context];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
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
	
	NSMutableArray *section1Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section2Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section3Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section4Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section5Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section6Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section7Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section8Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section9Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section10Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section11Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section12Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section13Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section14Sessions = [[NSMutableArray alloc] init];
	NSMutableArray *section15Sessions = [[NSMutableArray alloc] init];
	
	for (JZSession *session in mutableFetchResults) {
		if ([self startDate:[session startDate] andEndDate:[session endDate]
				 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 09:00:00 +0100"]
						and:[[NSDate alloc] initWithString:@"2010-09-08 10:00:00 +0100"]]) {
			[section1Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 10:15:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 11:15:00 +0100"]]) {
			[section2Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 11:45:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 12:45:00 +0100"]]) {
			[section3Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 13:00:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 14:00:00 +0100"]]) {
			[section4Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 14:15:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 15:15:00 +0100"]]) {
			[section5Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 15:45:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 16:45:00 +0100"]]) {
			[section6Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 17:00:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 18:00:00 +0100"]]) {
			[section7Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-08 18:15:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-08 19:15:00 +0100"]]) {
			[section8Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 09:00:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 10:00:00 +0100"]]) {
			[section9Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 10:15:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 11:15:00 +0100"]]) {
			[section10Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 11:45:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 12:45:00 +0100"]]) {
			[section11Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 13:00:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 14:00:00 +0100"]]) {
			[section12Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 14:15:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 15:15:00 +0100"]]) {
			[section13Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 15:45:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 16:45:00 +0100"]]) {
			[section14Sessions addObject:session];
		} else  if ([self startDate:[session startDate] andEndDate:[session endDate]
						 areBetween:[[NSDate alloc] initWithString:@"2010-09-09 17:00:00 +0100"]
								and:[[NSDate alloc] initWithString:@"2010-09-09 18:00:00 +0100"]]) {
			[section15Sessions addObject:session];
		} else {
			NSLog(@"Dates %@ %@ didn't find a match", [session startDate], [session endDate]);
		}
	}
	
	NSArray *keys = [[self sectionSessionHandler] getSectionTitles];
	NSArray *objects = [NSArray arrayWithObjects:section1Sessions,
						section2Sessions,
						section3Sessions,
						section4Sessions,
						section5Sessions,
						section6Sessions,
						section7Sessions,
						section8Sessions,
						section9Sessions,
						section10Sessions,
						section11Sessions,
						section12Sessions,
						section13Sessions,
						section14Sessions,
						section15Sessions,
						nil];
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	[mutableFetchResults release];
	[request release];
	
	return dictionary;
}

- (BOOL)startDate:(NSDate *)startDate andEndDate:(NSDate *)endDate areBetween:(NSDate *)earliestDate and:(NSDate *)latestDate {
	NSComparisonResult startCompare = [startDate compare:earliestDate];
	if (startCompare == NSOrderedAscending) {
		return false;
	}

	NSComparisonResult endCompare = [endDate compare:latestDate];
	if (endCompare == NSOrderedDescending) {
		return false;
	}
	
	return true;
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

