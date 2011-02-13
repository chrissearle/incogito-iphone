//
//  AbstractFeedbackController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "AbstractFeedbackController.h"
#import "FlurryAPI.h"
#import "JZSession.h"

@implementation AbstractFeedbackController

@synthesize session;
@synthesize nameField;
@synthesize emailField;
@synthesize commentField;

@synthesize ratingButton1;
@synthesize ratingButton2;
@synthesize ratingButton3;
@synthesize ratingButton4;
@synthesize ratingButton5;

@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Default scroll view to fit window
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		scrollView.frame = CGRectMake(0, 0, 320, 460);
		[scrollView setContentSize:CGSizeMake(320, 460)];
	} else {
		scrollView.frame = CGRectMake(10, 75, 745, 865);
		[scrollView setContentSize:CGSizeMake(745, 865)];
	}
	
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
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardDidShow:) 
												 name:UIKeyboardDidShowNotification 
											   object:self.view.window]; 
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidHide:)
												 name:UIKeyboardDidHideNotification
											   object:nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] 
	 removeObserver:self 
	 name:UIKeyboardWillShowNotification 
	 object:nil];
	
    [[NSNotificationCenter defaultCenter] 
	 removeObserver:self 
	 name:UIKeyboardWillHideNotification 
	 object:nil];
}

- (BOOL) scrollToFieldIfFirstResponder:(UIView *)field {
		if ([field isFirstResponder]) {
			CGRect fieldRect = [field frame];
			[scrollView scrollRectToVisible:fieldRect animated:YES];
			return YES;
		}
	
	return NO;
}

-(void) keyboardDidShow:(NSNotification *) notification {
		NSDictionary* info = [notification userInfo];
		
		NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
		CGSize keyboardSize = [aValue CGRectValue].size;
		
		CGRect viewFrame = [scrollView frame];
		viewFrame.size.height -= keyboardSize.height;
		scrollView.frame = viewFrame;

		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		{
			[self scrollToFieldIfFirstResponder:commentField];
		} else {
			[scrollView scrollRectToVisible:CGRectMake(0, 570, 745, 295) animated:YES];
		}
}

-(void) keyboardDidHide:(NSNotification *) notification {
		NSDictionary* info = [notification userInfo];
		
		NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
		CGSize keyboardSize = [aValue CGRectValue].size;
		
		CGRect viewFrame = [scrollView frame];
		viewFrame.size.height += keyboardSize.height;
		scrollView.frame = viewFrame;
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
	NSDictionary* plistDict = [[[NSDictionary alloc] initWithContentsOfFile:filePath] autorelease];
	
	NSString *url = [plistDict objectForKey:@"FeedbackUrl"];
	
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
	
	if (rating > 1) {
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
	}
	
	NSString* alertTitle = @"Feedback sent";
	NSString* alertMessage = @"Thankyou for your feedback";
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		// We only go back a view for iPhone
		clearView = YES;
	}
	
	if (rating == 0) {
		alertTitle = @"Not rated";
		alertMessage = @"You need to choose a rating between 1 and 5 stars";
		clearView = NO;
	}
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle: alertTitle
						  message: alertMessage
						  delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (clearView == YES) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)ratingButtonClicked:(id)sender {
	if ([commentField isFirstResponder]) {
		[commentField resignFirstResponder];
	}
	
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

-(BOOL) textFieldShouldReturn:(UITextField *) textFieldView {  
    [textFieldView resignFirstResponder];
    return NO;
}


@end
