//
//  FeedbackController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "FeedbackController.h"
#import "FlurryAPI.h"
#import "JZSession.h"

@implementation FeedbackController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[FlurryAPI logEvent:@"Showing Feedback" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															[session title],
															@"Title",
															[session jzId],
															@"ID", 
															nil]];
}


@end
