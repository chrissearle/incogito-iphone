    //
//  FeedbackController.m
//  incogito
//
//  Created by Chris Searle on 21.09.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "FeedbackController.h"
#import "FlurryAPI.h"
#import "JZSession.h"

@implementation FeedbackController

@synthesize session;
@synthesize nameField;
@synthesize emailField;
@synthesize commentField;

@synthesize ratingButton1;
@synthesize ratingButton2;
@synthesize ratingButton3;
@synthesize ratingButton4;
@synthesize ratingButton5;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Feedback";
	
	UIBarButtonItem *button = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(send:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = button;
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	const CGFloat myColor[] = {0.67, 0.67, 0.67, 1.0};
	CGColorRef colour = CGColorCreate(rgb, myColor);
	CGColorSpaceRelease(rgb);
	
	[[commentField layer] setCornerRadius:8.0f];
	[[commentField layer] setMasksToBounds:YES];
	[[commentField layer] setBorderWidth:1.0];
	[[commentField layer] setBorderColor:colour];
	
	CGColorRelease(colour);
	
	
}


- (void)viewWillAppear:(BOOL)animated {
	[FlurryAPI logEvent:@"Showing Feedback" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
														  [session title],
														  @"Title",
														  [session jzId],
														  @"ID", 
														  nil]];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (void)send:(id) sender {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"incogito" ofType:@"plist"];
	NSDictionary* plistDict = [[[NSDictionary alloc] initWithContentsOfFile:filePath] retain];
	
	NSString *url = [plistDict objectForKey:@"FeedbackUrl"];
	
	[plistDict release];

	int rating = 0;
	
	if (self.ratingButton5.selected) {
		rating = 5;
	} else if (self.ratingButton4.selected) {
		rating = 4;
	} else if (self.ratingButton3.selected) {
		rating = 3;
	} else if (self.ratingButton2.selected) {
		rating = 2;
	} else if (self.ratingButton1.selected) {
		rating = 1;
	}

	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;

	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];

    
	NSString *postString = [NSString stringWithFormat:@"jzid=%@&title=%@&name=%@&email=%@&rating=%d&comment=%@",
							[session jzId],
							[session title],
							[nameField text],
							[emailField text],
							rating,
							[commentField text]];
	
	NSLog(@"post: %@", postString);
	
	[urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
	
	[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	
	app.networkActivityIndicatorVisible = NO;

	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle: @"Feedback sent"
						  message: @"Thankyou for your feedback"
						  delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)ratingButtonClicked:(id)sender {

	NSArray *buttons = [NSArray arrayWithObjects: self.ratingButton1, self.ratingButton2, self.ratingButton3, self.ratingButton4, self.ratingButton5, nil];

	self.ratingButton5.selected = NO;
	self.ratingButton4.selected = NO;
	self.ratingButton3.selected = NO;
	self.ratingButton2.selected = NO;
	self.ratingButton1.selected = NO;
	
	switch ([buttons indexOfObject:sender]) {
		case 4:
			self.ratingButton5.selected = YES;
		case 3:
			self.ratingButton4.selected = YES;
		case 2:
			self.ratingButton3.selected = YES;
		case 1:
			self.ratingButton2.selected = YES;
		default:
			self.ratingButton1.selected = YES;
	}
}

@end
