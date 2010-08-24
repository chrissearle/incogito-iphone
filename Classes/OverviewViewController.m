//
//  OverviewViewController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "OverviewViewController.h"
#import "IncogitoAppDelegate.h"
#import "SectionSessionHandler.h"
#import "RefreshCommonViewController.h"

@implementation OverviewViewController

@synthesize search;
@synthesize currentSearch;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Overview - about to check for data", [[[NSDate alloc] init] autorelease]);
#endif

	currentSearch = @"";
	justCleared = NO;
	
	[self checkForData];
	
#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Overview - about to load data", [[[NSDate alloc] init] autorelease]);
#endif
	
	[self loadSessionData];

#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Overview - loaded data", [[[NSDate alloc] init] autorelease]);
#endif
	
}

- (void) checkForData {
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];
	
	NSUInteger count = [handler getActiveSessionCount];
	
	if (count == 0) {
		RefreshCommonViewController *controller = [[RefreshCommonViewController alloc] initWithNibName:@"Update" bundle:[NSBundle mainBundle]];
		[controller setFirstTimeTextVisibility:YES];
		[self.tabBarController presentModalViewController:controller animated:YES];
		[controller release];
	}
}

- (void) loadSessionData {
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];
	
	if ([currentSearch isEqual:@""]) {
		[self setSessions:[handler getSessions]];
	} else {
		[self setSessions:[handler getSessionsMatching:currentSearch]];
	}
	
	NSMutableArray *titles = [NSMutableArray arrayWithArray:[sessions allKeys]];
	
	[titles sortUsingSelector:@selector(compare:)];

	[self setSectionTitles:[[[NSArray alloc] initWithArray:titles] autorelease]];
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

- (IBAction) search:(id)sender {
	[search resignFirstResponder];

	self.currentSearch = [search text];
	[self loadSessionData];
	[tv reloadData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (justCleared == YES) {
		justCleared = NO;
		
		[self search:textField];
		
		return NO;
	}
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	justCleared = YES;
	return YES;
}

@end
