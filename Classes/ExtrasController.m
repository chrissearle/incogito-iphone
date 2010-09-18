//
//  ExtrasController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "ExtrasController.h"
#import "SHK.h"
#import "JZSession.h"
#import "FlurryAPI.h"

@implementation ExtrasController

@synthesize shareButton;
@synthesize shareLinkButton;
@synthesize sharePicButton;
@synthesize session;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Extras";
}

- (void)viewWillAppear:(BOOL)animated {
	[FlurryAPI logEvent:@"Showing Extras" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
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

- (void)share:(id)sender {
	NSString *text = [NSString stringWithFormat:@"#JavaZone - %@", [session title]];
	
	SHKItem *item = [SHKItem text:text];
	
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showFromRect:[shareButton bounds] inView:[self view] animated:YES];
}

- (void)shareLink:(id)sender {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://javazone.no/incogito10/events/JavaZone%202010/sessions/%@", [session title]]];

	SHKItem *item = [SHKItem URL:url title:[session title]];
	
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showFromRect:[shareLinkButton bounds] inView:[self view] animated:YES];
}


@end
