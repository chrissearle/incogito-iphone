//
//  FeedbackController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "FeedbackController.h"
#import "FlurryAPI.h"
#import "JZSession.h"
#import "JavaZonePrefs.h"

@implementation FeedbackController

@synthesize session;
@synthesize emailField;
@synthesize formField;
@synthesize feedbackURL;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[FlurryAPI logEvent:@"Showing Feedback" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															[session title],
															@"Title",
															[session jzId],
															@"ID", 
															nil]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Feedback";
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	const CGFloat myColor[] = {0.67, 0.67, 0.67, 1.0};
	CGColorRef colour = CGColorCreate(rgb, myColor);
	CGColorSpaceRelease(rgb);
	
	[[formField layer] setCornerRadius:8.0f];
	[[formField layer] setMasksToBounds:YES];
	[[formField layer] setBorderWidth:1.0];
	[[formField layer] setBorderColor:colour];
	
	CGColorRelease(colour);
    
    NSLog(@"Initializing registered e-mail %@", [JavaZonePrefs registeredEmail]);
    
    [emailField setText:[JavaZonePrefs registeredEmail]];
    
    [formField loadRequest:[NSURLRequest requestWithURL:feedbackURL]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // TODO - set in HTML
    
    NSLog(@"Storing registered e-mail %@", [textField text]);
    
    [JavaZonePrefs setRegisteredEmail:[textField text]];
}

@end
