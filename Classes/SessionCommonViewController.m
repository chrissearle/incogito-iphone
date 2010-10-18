//
//  SessionCommonViewController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SessionCommonViewController.h"
#import "JZSession.h"
#import "JZSessionBio.h"
#import "DetailedSessionViewController.h"
#import "IncogitoAppDelegate.h"
#import "FlurryAPI.h"
#import "SessionTableViewCell.h"

@implementation SessionCommonViewController

@synthesize sectionTitles;
@synthesize sessions;
@synthesize tv;
@synthesize appDelegate;

- (void) loadSessionData {
	// Stub
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setAppDelegate:[[UIApplication sharedApplication] delegate]];
	
	[FlurryAPI countPageViews:[self navigationController]];
	
	tv.rowHeight = 85;
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
	[sessions release];
	[sectionTitles release];

    [super dealloc];
}

- (NSString *)getSelectedSessionTitle:(NSInteger)section {
	return [sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *sectionName = [self getSelectedSessionTitle:section];
	
	if ([[sessions allKeys] containsObject:sectionName]) {
		NSArray *sectionSessions = [sessions objectForKey:sectionName];
		
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
	JZSession *session = [[sessions objectForKey:[self getSelectedSessionTitle:indexPath.section]] objectAtIndex:indexPath.row];

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
	
	UIImageView *favouriteImageView = [cell favouriteImage];
	
	if ([session userSession]) {
		[favouriteImageView setImage:[UIImage imageNamed:@"star-checked.png"]];
	} else {
		[favouriteImageView setImage:[UIImage imageNamed:@"star.png"]];
	}
	
	[self addLabels:[session labels] toCell:cell];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [sectionTitles objectAtIndex:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *sectionTitle = [self getSelectedSessionTitle:indexPath.section];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	DetailedSessionViewController *controller = [[DetailedSessionViewController alloc] initWithNibName:@"DetailedSessionView" bundle:[NSBundle mainBundle]];
	controller.session = [[sessions objectForKey:sectionTitle] objectAtIndex:indexPath.row];
	
#ifndef SHOW_TAB_BAR_ON_DETAILS_VIEW
	[controller setHidesBottomBarWhenPushed:YES];
#endif
	
	[[self navigationController] pushViewController:controller animated:YES];
	[controller release], controller = nil;
}

@end
