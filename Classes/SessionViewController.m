//
//  SessionViewController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SessionViewController.h"
#import "IncogitoAppDelegate.h"
#import "SectionSessionHandler.h"
#import "FilterViewController.h"
#import "AweZoneController.h"
#import "JZSession.h"
#import "JZSessionBio.h"
#import "DetailedSessionViewController.h"
#import "IncogitoAppDelegate.h"
#import "SessionTableViewCell.h"
#import "JavaZonePrefs.h"
#import "JavazoneSessionsRetriever.h"

@implementation SessionViewController

@synthesize currentSearch;
@synthesize sb;
@synthesize sectionTitles;
@synthesize sessions;
@synthesize tv;
@synthesize appDelegate;
@synthesize lastSuccessfulUpdate;
@synthesize HUD;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    self.appDelegate = [[UIApplication sharedApplication] delegate];
	
	[FlurryAnalytics logAllPageViews:[self navigationController]];
	
	tv.rowHeight = 85;

	AppLog(@"Overview - about to check for data");

	currentSearch = @"";
	
	[self checkForData];
	
	AppLog(@"Overview - about to load data");
	
	[self loadSessionData];

	AppLog(@"Overview - loaded data");
}

- (void) setTitleFromPrefs {
    NSString *savedKey = [self.appDelegate getLabelFilter];
    
    if ([savedKey isEqual:@"All"]) {
        self.navigationItem.title = @"Sessions";
    } else {
        self.navigationItem.title = savedKey;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [self setTitleFromPrefs];

	[FlurryAnalytics logEvent:@"Showing Overview"];
}

- (void) checkForData {
	SectionSessionHandler *handler = [self.appDelegate sectionSessionHandler];
	
	NSUInteger count = [handler getActiveSessionCount];
	
	if (count == 0) {
		[self sync];
	}
}

- (IBAction)refresh:(id)sender {
    [self sync];
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
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.tv = nil;
    
    self.appDelegate = nil;

    self.sb = nil;
}

- (void)dealloc {
    [currentSearch release];
    [sb release];
	[sessions release];
	[sectionTitles release];
    [tv release];
    [appDelegate release];
    [lastSuccessfulUpdate release];
    [HUD release];
    
    
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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)curlPage:(id)sender {
    FilterViewController *controller = [[FilterViewController alloc] initWithNibName:@"Filter" bundle:[NSBundle mainBundle]];

    [controller setViewShouldRefreshDelegate:self];
    
    [controller setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentModalViewController:controller animated:YES]; 
    [controller release];
}

- (void)party:(id)sender {
    AweZoneController *controller = [[AweZoneController alloc] initWithNibName:@"AweZone" bundle:[NSBundle mainBundle]];

    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

- (void)reloadView {
    [self loadSessionData];
    [[self tv] reloadData];
}

- (void)refeshView:(BOOL)reload withFull:(BOOL)full {
    if (reload == YES) {
        if (full == YES) {
            [self sync];
        } else {
            [self reloadView];
        }
        [self setTitleFromPrefs];
    }
}

- (NSString *)getSelectedSessionTitle:(NSInteger)section {
	return [self.sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *sectionName = [self getSelectedSessionTitle:section];
	
	if ([[self.sessions allKeys] containsObject:sectionName]) {
		NSArray *sectionSessions = [self.sessions objectForKey:sectionName];
		
		return [sectionSessions count];
	} else {
		return 0;
	}
}

- (void)addLabels:(NSSet *)labels toCell:(SessionTableViewCell *)cell {
	int offset = 0;
	
	for (UIView *view in cell.iconBarView.subviews) {
		[view removeFromSuperview];
	}
	
	if (!(nil == labels || [labels count] == 0)) {
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
		NSSortDescriptor * titleDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES] autorelease];
		
		NSArray * descriptors = [NSArray arrayWithObjects:titleDescriptor, nil];
		
		for (JZLabel *label in [[labels allObjects] sortedArrayUsingDescriptors:descriptors]) {
			NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:@"labelIcons"],[label jzId]];
            
			NSData *data1 = [NSData dataWithContentsOfFile:pngFilePath];
			
			UIImage *labelImageFile = [UIImage imageWithData:data1];
			
			CGRect frame = CGRectMake(offset, 0, labelImageFile.size.width, labelImageFile.size.height);
			
			offset += 15;
			
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
			
			[imageView setImage:labelImageFile];
			
			[cell.iconBarView addSubview:imageView];
			
			[imageView release];
		}
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	JZSession *session = [[self.sessions objectForKey:[self getSelectedSessionTitle:indexPath.section]] objectAtIndex:indexPath.row];
    
	static NSString *cellId = @"SessionCell";
	
	SessionTableViewCell *cell = (SessionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
	if (nil == cell) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SessionCell" owner:nil options:nil];
        
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (SessionTableViewCell *)currentObject;
				break;
			}
		}
	}
	
	cell.jzId = session.jzId;
	
	NSMutableArray *speakerNames = [[NSMutableArray alloc] initWithCapacity:[session.speakers count]];
	
	for (JZSessionBio *bio in session.speakers) {
		[speakerNames addObject:[bio name]];
	}
	
	cell.sessionLabel.text = session.title;
	cell.speakerLabel.text = [NSString stringWithFormat:@"Room %@ - %@", session.room, [speakerNames componentsJoinedByString:@", "]];
    
	[speakerNames release];
	
	UIImageView *levelImageView = [cell levelImage];
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:@"levelIcons"],[session level]];
	
	NSData *data1 = [NSData dataWithContentsOfFile:pngFilePath];
	
	UIImage *levelImageFile = [UIImage imageWithData:data1];
    
	[levelImageView setImage:levelImageFile];
	
	UIButton *favouriteImage = [cell favouriteImage];
    
	if ([session userSession]) {
		[favouriteImage setSelected:YES];
	} else {
		[favouriteImage setSelected:NO];
	}
	
	[favouriteImage addTarget:self action:@selector(toggleFavourite:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addLabels:[session labels] toCell:cell];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.sectionTitles objectAtIndex:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.sb setShowsCancelButton:NO animated:YES];
    [self.sb resignFirstResponder];

	NSString *sectionTitle = [self getSelectedSessionTitle:indexPath.section];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
	DetailedSessionViewController *controller = [[DetailedSessionViewController alloc] initWithNibName:@"DetailedSessionView" bundle:[NSBundle mainBundle]];
    
	controller.session = [[self.sessions objectForKey:sectionTitle] objectAtIndex:indexPath.row];
	
#ifndef SHOW_TAB_BAR_ON_DETAILS_VIEW
	[controller setHidesBottomBarWhenPushed:YES];
#endif
	
	[[self navigationController] pushViewController:controller animated:YES];
	[controller release], controller = nil;
}

- (IBAction)toggleFavourite:(id)sender {
	UIButton *button = (UIButton *)sender;
    
	UIView *view = [button superview];
	
	while (view != nil) {
		if ([view isKindOfClass:[SessionTableViewCell class]]) {
			SessionTableViewCell *cell = (SessionTableViewCell *)view;
			
			AppLog(@"JZ %@", [cell jzId]);
            
			SectionSessionHandler *handler = [self.appDelegate sectionSessionHandler];
			
			[handler toggleFavouriteForSession:[cell jzId]];
			
			[self refresh:self];
			
			break;
		}
        
		view = [view superview];
	}
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [self.HUD removeFromSuperview];
    
    if (abs([[self lastSuccessfulUpdate] timeIntervalSinceDate:[JavaZonePrefs lastSuccessfulUpdate]]) < 2) {
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Download failed"
							  message: @"Sessions unavailable - please try again later. You can start a refresh from the Settings tab."
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
        
        return;
    }
    
	SectionSessionHandler *handler = [self.appDelegate sectionSessionHandler];
	
	NSUInteger count = [handler getActiveSessionCount];
    
	if (count == 0) {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Download failed"
							  message: @"Unable to download sessions - check your connection and try again. You can start a refresh from the Settings tab."
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	} else {
        //		[self.appDelegate refreshViewData];
        [self loadSessionData];
        [[self tv] reloadData];
	}
}

- (void)sync {
    [self setLastSuccessfulUpdate:[JavaZonePrefs lastSuccessfulUpdate]];
    
	self.HUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    
	JavazoneSessionsRetriever *retriever = [[[JavazoneSessionsRetriever alloc] init] autorelease];
    
	retriever.managedObjectContext = [self.appDelegate managedObjectContext];
	retriever.HUD = self.HUD;
    
	retriever.urlString = [JavaZonePrefs sessionUrl];
    
	// Add HUD to screen
	[self.view addSubview:self.HUD];
    
	// Register for HUD callbacks so we can remove it from the window at the right time
	self.HUD.delegate = self;
    
	self.HUD.labelText = @"Preparing";
    
	// Show the HUD while the provided method executes in a new thread
	[self.HUD showWhileExecuting:@selector(retrieveSessions:) onTarget:retriever withObject:nil animated:YES];
}

@end
