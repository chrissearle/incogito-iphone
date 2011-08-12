//
//  OverviewViewController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "OverviewViewController.h"
#import "IncogitoAppDelegate.h"
#import "SectionSessionHandler.h"

@implementation OverviewViewController

@synthesize currentSearch;
@synthesize sb;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

#ifdef LOG_FUNCTION_TIMES
	AppLog(@"%@ Overview - about to check for data", [[[NSDate alloc] init] autorelease]);
#endif

	currentSearch = @"";
	
	[self checkForData];
	
#ifdef LOG_FUNCTION_TIMES
	AppLog(@"%@ Overview - about to load data", [[[NSDate alloc] init] autorelease]);
#endif
	
	[self loadSessionData];

#ifdef LOG_FUNCTION_TIMES
	AppLog(@"%@ Overview - loaded data", [[[NSDate alloc] init] autorelease]);
#endif
	
}

- (void) viewWillAppear:(BOOL)animated {
	[FlurryAPI logEvent:@"Showing Overview"];
}

- (void) checkForData {
	SectionSessionHandler *handler = [appDelegate sectionSessionHandler];
	
	NSUInteger count = [handler getActiveSessionCount];
	
	if (count == 0) {
		[self sync];
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

- (void) search:(NSString *)searchText {
	[FlurryAPI logEvent:@"Searched" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
													searchText,
													@"Search Text",
													nil]];
	
	self.currentSearch = searchText;
	[self loadSessionData];
	[tv reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if ([searchText length] == 0) {
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
	}
	[self search:[searchBar text]];
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar
{   
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];   
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
	
    tv.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
	
    tv.scrollEnabled = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self search:[searchBar text]];
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
	
    tv.scrollEnabled = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sb setShowsCancelButton:NO animated:YES];
    [sb resignFirstResponder];
	
    tv.scrollEnabled = YES;
	
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
