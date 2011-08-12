//
//  SectionSessionHandler.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SectionSessionHandler.h"

#import "Section.h"
#import "JZSession.h"
#import "UserSession.h"

@implementation SectionSessionHandler

@synthesize managedObjectContext;


- (NSArray *)getSections {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Section" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError *error = nil;

	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];

	if (nil != error) {
		[mutableFetchResults release];
		AppLog(@"%@:%@ Error fetching sections: %@", [self class], _cmd, [error localizedDescription]);
		return nil;
	}
	
	NSArray *sections = [[[NSArray alloc] initWithArray:mutableFetchResults] autorelease];
	[mutableFetchResults release];
	
	return sections;
}

- (NSArray *)getSessionsForSection:(Section *)section {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"room" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(active == %@) AND (startDate >= %@) AND (endDate <= %@)", [NSNumber numberWithBool:true], [section startDate], [section endDate]];
	
	[request setPredicate:predicate];
	
	NSError *error = nil;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];
	
	if (nil != error) {
		[mutableFetchResults release];
		AppLog(@"%@:%@ Error fetching sessions: %@", [self class], _cmd, [error localizedDescription]);
		return nil;
	}
	
	NSArray *sessions = [[[NSArray alloc] initWithArray:mutableFetchResults] autorelease];
	[mutableFetchResults release];
	
	return [self filterSessionList:sessions];
}

- (NSArray *)getSessionsForSection:(Section *)section matching:(NSString *)search {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"room" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(active == %@) AND (startDate >= %@) AND (endDate <= %@) AND (title contains[cd] %@ OR ANY speakers.name  contains[cd] %@)", [NSNumber numberWithBool:true], [section startDate], [section endDate], search, search];
	
	[request setPredicate:predicate];
	
	NSError *error = nil;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];
	
	if (nil != error) {
		[mutableFetchResults release];
		AppLog(@"%@:%@ Error fetching sessions: %@", [self class], _cmd, [error localizedDescription]);
		return nil;
	}
	
	NSArray *sessions = [[[NSArray alloc] initWithArray:mutableFetchResults] autorelease];
	[mutableFetchResults release];
	
	return [self filterSessionList:sessions];
}

- (NSArray *)getFavouriteSessionsForSection:(Section *)section {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"room" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(userSession.@count > 0) && (active == %@) AND (startDate >= %@) AND (endDate <= %@)", [NSNumber numberWithBool:true], [section startDate], [section endDate]];

	[request setPredicate:predicate];
	
	NSError *error = nil;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];
	
	if (nil != error) {
		[mutableFetchResults release];
		AppLog(@"%@:%@ Error fetching sessions: %@", [self class], _cmd, [error localizedDescription]);
		return nil;
	}

	NSArray *sessions = [[[NSArray alloc] initWithArray:mutableFetchResults] autorelease];
	[mutableFetchResults release];
	
	return [self filterSessionList:sessions];
}

- (NSDictionary *)getSessions {
	NSArray *sections = [self getSections];
	
	NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:[sections count]];
	NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:[sections count]];
	
	for (Section *section in sections) {
		NSArray *sessions = [self getSessionsForSection:section];
		
		if ([sessions count] > 0) {
			[keys addObject:[section title]];
			[objects addObject:sessions];
		}
	}
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	[objects release];
	[keys release];
	
	return dictionary;
}

- (NSDictionary *)getSessionsMatching:(NSString *)search {
	NSArray *sections = [self getSections];
	
	NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:[sections count]];
	NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:[sections count]];
	
	for (Section *section in sections) {
		NSArray *sessions = [self getSessionsForSection:section matching:search];
		
		if ([sessions count] > 0) {
			[keys addObject:[section title]];
			[objects addObject:sessions];
		}
	}
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	[objects release];
	[keys release];
	
	return dictionary;
}

- (NSString *)getSectionTitleForDate:(NSDate *)date {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Section" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(startDate <= %@) AND (endDate >= %@)", date, date];
	
	[request setPredicate:predicate];
	
	NSError *error = nil;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];
	
	if (nil != error) {
		[mutableFetchResults release];
		AppLog(@"%@:%@ Error fetching sections: %@", [self class], _cmd, [error localizedDescription]);
		return nil;
	}

	NSArray *sections = [[[NSArray alloc] initWithArray:mutableFetchResults] autorelease];
	[mutableFetchResults release];
	
	if (nil == sections || [sections count] == 0) {
		return nil;
	}
	
	return [[sections objectAtIndex:0] title];
}

- (NSString *)getNextSectionTitleForDate:(NSDate *)date {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Section" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(startDate > %@)", date];
	
	[request setPredicate:predicate];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError *error = nil;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];
	
	if (nil != error) {
		[mutableFetchResults release];
		AppLog(@"%@:%@ Error fetching sections: %@", [self class], _cmd, [error localizedDescription]);
		return nil;
	}
	
	NSArray *sections = [[[NSArray alloc] initWithArray:mutableFetchResults] autorelease];
	
	[mutableFetchResults release];
	
	if (nil == sections || [sections count] == 0) {
		return nil;
	}
	
	return [[sections objectAtIndex:0] title];
}

- (JZSession *)getSessionForJZId:(NSString *)jzId {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(jzId == %@)", jzId];
	
	[request setPredicate:predicate];
	
	NSError *error = nil;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];

	if (nil != error) {
		[mutableFetchResults release];
		AppLog(@"%@:%@ Error fetching sessions: %@", [self class], _cmd, [error localizedDescription]);
		return nil;
	}
	
	NSArray *sessions = [[[NSArray alloc] initWithArray:mutableFetchResults] autorelease];
	[mutableFetchResults release];
	
	if (nil == sessions || [sessions count] == 0) {
		return nil;
	}
	
	return [sessions objectAtIndex:0];
}

- (NSDictionary *)getFavouriteSessions {
	NSArray *sections = [self getSections];
	
	NSMutableArray *keys = [[NSMutableArray alloc] init];
	
	NSMutableArray *objects = [[NSMutableArray alloc] init];
	
	for (Section *section in sections) {
		NSArray *sessions = [self getFavouriteSessionsForSection:section];
		
		if (nil != sessions && [sessions count] > 0) {
			[keys addObject:[section title]];
			[objects addObject:sessions];
		}
	}
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	[objects release];
	[keys release];
	
	return dictionary;	
}

- (NSUInteger)getActiveSessionCount {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	
	[request setEntity:entityDescription];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"(active == %@)", [NSNumber numberWithBool:true]];
	
	[request setPredicate:predicate];
		
	NSError *error = nil;
	
	NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];

	if (nil != error) {
		AppLog(@"%@:%@ Error fetching sessions: %@", [self class], _cmd, [error localizedDescription]);
		return 0;
	}
	
	return count;
}

- (NSDate *)sessionStartForNotification:(JZSession *)session {
#ifdef NOW_AND_NEXT_USE_TEST_DATE
	// In debug mode we will use the current time of day but always the first day of JZ. Otherwise we couldn't test until JZ started ;)
	NSDate *current = [NSDate date];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comp = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:current];
	NSDateComponents *sessionComp = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:[session startDate]];
	
	NSDate *sessionDate = [[[NSDate alloc] initWithString:[NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:00 +0200", [comp year], [comp month], [comp day], [sessionComp hour], [sessionComp minute]]] autorelease];
#else
	NSDate *sessionDate = [session startDate];
#endif
    
    return [NSDate dateWithTimeInterval: -300 sinceDate:sessionDate];
}

- (void) addNotification:(JZSession *)session {
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    
    NSDate *sessionStart = [self sessionStartForNotification:session];
    
    [notification setFireDate:sessionStart];

    [notification setAlertBody:[NSString stringWithFormat:@"Your next session is %@ in room %@ in 5 mins", [session title], [session room]]];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [notification setHasAction:NO];
    [notification setTimeZone:[NSTimeZone localTimeZone]];
    [notification setUserInfo:[NSDictionary dictionaryWithObject:[session jzId] forKey:@"jzId"]];
    
    AppLog(@"Adding session %@ at %@ to notifications", [session title], sessionStart);
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void) removeNotification:(JZSession *)session {
    AppLog(@"Looking for session %@ with ID %@", [session title], [session jzId]);
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *notification in notifications) {
        NSDictionary *userInfo = [notification userInfo];
        
        AppLog(@"Saw a notification for %@", userInfo);
        
        if (userInfo != nil && [[userInfo allKeys] containsObject:@"jzId"]) {
            if ([[userInfo objectForKey:@"jzId"] isEqual:[session jzId]]) {
                AppLog(@"Removing notification at %@ from notifications", [notification fireDate]);

                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
}

- (void) toggleFavouriteForSession:(NSString *)jzId {
	JZSession *session = [self getSessionForJZId:jzId];
	
	if ([session userSession]) {
		[self setFavouriteForSession:session withBoolean:NO];
        [self removeNotification:session];
	} else {
		[self setFavouriteForSession:session withBoolean:YES];
        [self addNotification:session];
	}
}

- (void) setFavouriteForSession:(JZSession *)session withBoolean:(BOOL)favouriteFlag {
	JZSession *sessionInContext = [self getSessionForJZId:[session jzId]];
	
	if (favouriteFlag == NO) {
		if ([sessionInContext userSession]) {
			[managedObjectContext deleteObject:[sessionInContext userSession]];
			[sessionInContext setUserSession:nil];
		}
	}
	
	if (favouriteFlag == YES) {
		if ([sessionInContext userSession] == nil) {
			UserSession *userSession = (UserSession *)[NSEntityDescription insertNewObjectForEntityForName:@"UserSession" inManagedObjectContext:managedObjectContext];
			
			[sessionInContext setUserSession:userSession];
		}
	}

	NSError *error = nil;
	
	if (![managedObjectContext save:&error]) {
		if (nil != error) {
			AppLog(@"%@:%@ Error saving sessions: %@", [self class], _cmd, [error localizedDescription]);
			return;
		}
	}	
}

- (NSDictionary *)getUniqueLabels {
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZLabel" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	[request setReturnsDistinctResults:YES];
	
	NSError *error = nil;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];
	
	if (nil != error) {
		[mutableFetchResults release];
		AppLog(@"%@:%@ Error fetching uniqueLabels: %@", [self class], _cmd, [error localizedDescription]);
		return nil;
	}
	
	NSArray *labels = [[[NSArray alloc] initWithArray:mutableFetchResults] autorelease];
	[mutableFetchResults release];
	
	NSMutableArray *keys = [[NSMutableArray alloc] init];
	
	NSMutableArray *objects = [[NSMutableArray alloc] init];
	
	for (JZLabel *label in labels) {
		[keys addObject:[label jzId]];
		[objects addObject:[label title]];
	}
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	[objects release];
	[keys release];
	
	return dictionary;	
}

- (NSString *)getStoredFilter {
	NSString *label = @"All";

	if (nil != [[NSUserDefaults standardUserDefaults] stringForKey:@"labelFilter"]) {
		label = [[NSUserDefaults standardUserDefaults] stringForKey:@"labelFilter"];
	}

	return label;
}

- (NSArray *)filterSessionList:(NSArray *)sessions {
	NSString *filter = [self getStoredFilter];
	
	if ([filter isEqual:@"All"]) {
		return sessions;
	}
	
	NSMutableArray *matchingSessions = [[NSMutableArray alloc] init];
	
	for (JZSession *session in sessions) {
		for (JZLabel *label in [session labels]) {
			if ([[label title] isEqual:filter]) {
				[matchingSessions addObject:session];
			}
		}
	}

	NSArray *filteredSessions = [[[NSArray alloc] initWithArray:matchingSessions] autorelease];
	[matchingSessions release];
	
	return filteredSessions;
}

- (NSArray *)getAllSessions {
    NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"JZSession" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entityDescription];
	
	NSError *error = nil;
    
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];
    
	if (nil != error) {
		[mutableFetchResults release];
		AppLog(@"%@:%@ Error fetching sessions: %@", [self class], _cmd, [error localizedDescription]);
		return nil;
	}
	
	NSArray *sessions = [[[NSArray alloc] initWithArray:mutableFetchResults] autorelease];
	[mutableFetchResults release];
	
	return sessions;
}

- (void)deleteSession:(JZSession *)session {
    if ([session userSession] != nil) {
        [managedObjectContext deleteObject:[session userSession]];
    }
    [managedObjectContext deleteObject:session];
}

- (void)deleteSection:(Section *)section {
    [managedObjectContext deleteObject:section];
}


@end
