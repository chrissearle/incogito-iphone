//
//  ExtrasController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "ExtrasController.h"
#import "SHK.h"
#import "JZSession.h"
#import "FlurryAPI.h"
#import "FeedbackController.h"
#import "VideoMapper.h"

@implementation ExtrasController

@synthesize session;
@synthesize sections;
@synthesize sectionCells;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Extras";
    
    NSMutableDictionary *cells = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableArray *titles = [[[NSMutableArray alloc] init] autorelease];
    
    [titles addObject:@"Sharing"];
    [cells  setObject:[NSArray arrayWithObjects:@"Share", @"Share link", nil] forKey:@"Sharing"];
    
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [titles addObject:@"Feedback"];
        [cells  setObject:[NSArray arrayWithObjects:@"Rate or give feedback", nil] forKey:@"Feedback"];
    }
    
    if ([VideoMapper streamingUrlForSession:[session jzId]] != nil) {
        [titles addObject:@"Video"];
        [cells  setObject:[NSArray arrayWithObjects:@"Stream video", nil] forKey:@"Video"];
    }
    
    sections = [NSArray arrayWithArray:titles];
    sectionCells = [NSDictionary dictionaryWithDictionary:cells];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSString *)getTitle:(NSInteger)section {
    return [sections objectAtIndex:section];
}

- (NSArray *)getCellsForTitle:(NSString *)title {
    return [sectionCells objectForKey:title];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = [self getTitle:section];
    NSArray *cellList = [self getCellsForTitle:sectionTitle];
    
    return cellList.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self getTitle:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"extrasCell"];
	
	if (nil == cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"extrasCell"] autorelease];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    NSString *sectionTitle = [self getTitle:indexPath.section];
    NSArray *cellList = [self getCellsForTitle:sectionTitle];

    cell.textLabel.text = [cellList objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSString *sectionTitle = [self getTitle:indexPath.section];
	
    if ([sectionTitle isEqualToString:@"Sharing"]) {
        SHKItem *item = nil;
        
        switch (indexPath.row) {
            case 0:
            {
                NSString *text = [NSString stringWithFormat:@"#JavaZone - %@", [session title]];
                
                item = [SHKItem text:text];
                
                break;
            }
            case 1:
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://javazone.no/incogito10/events/JavaZone%202010/sessions/%@", [session title]]];
                
                item = [SHKItem URL:url title:[session title]];
                break;
            }
            default:
                break;
        }
        // Get the ShareKit action sheet
        SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
        
        // Display the action sheet
        [actionSheet showInView:[self view]];
    } else if ([sectionTitle isEqualToString:@"Feedback"]) {
        FeedbackController *controller = [[FeedbackController alloc] initWithNibName:@"Feedback" bundle:[NSBundle mainBundle]];
        controller.session = session;
        
        [[self navigationController] pushViewController:controller animated:YES];
        [controller release], controller = nil;
    } else if ([sectionTitle isEqualToString:@"Video"]) {
        NSString *streamingUrl = [VideoMapper streamingUrlForSession:[session jzId]];
        
        NSLog(@"Streaming URL %@", streamingUrl);
    }
}




@end
