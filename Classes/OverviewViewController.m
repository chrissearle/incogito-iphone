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

	AppLog(@"Overview - about to check for data");

	currentSearch = @"";
	
	[self checkForData];
	
	AppLog(@"Overview - about to load data");
	
	[self loadSessionData];

	AppLog(@"Overview - loaded data");
}

- (void) viewWillAppear:(BOOL)animated {
	[FlurryAnalytics logEvent:@"Showing Overview"];
}

- (void) checkForData {
	SectionSessionHandler *handler = [self.appDelegate sectionSessionHandler];
	
	NSUInteger count = [handler getActiveSessionCount];
	
	if (count == 0) {
		[self sync];
	}
}

- (void) loadSessionData {
	SectionSessionHandler *handler = [self.appDelegate sectionSessionHandler];
	
	if ([currentSearch isEqual:@""]) {
        self.sessions = [handler getSessions];
	} else {
        self.sessions = [handler getSessionsMatching:currentSearch];
	}
	
	NSMutableArray *titles = [NSMutableArray arrayWithArray:[self.sessions allKeys]];
	
	[titles sortUsingSelector:@selector(compare:)];

	self.sectionTitles = [[[NSArray alloc] initWithArray:titles] autorelease];
    
    NSString *filter = [self.appDelegate getLabelFilter];
    
    if ([filter isEqualToString:@"All"]) {
        self.navigationItem.title = @"Sessions";
    } else {
        self.navigationItem.title = filter;
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.sb = nil;
}

- (void)dealloc {
    [currentSearch release];
    [sb release];
    
    [super dealloc];
}

- (void) search:(NSString *)searchText {
	[FlurryAnalytics logEvent:@"Searched" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
													searchText,
													@"Search Text",
													nil]];
	
	self.currentSearch = searchText;
	[self loadSessionData];
	[self.tv reloadData];
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
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self search:[searchBar text]];
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.sb setShowsCancelButton:NO animated:YES];
    [self.sb resignFirstResponder];
	
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
