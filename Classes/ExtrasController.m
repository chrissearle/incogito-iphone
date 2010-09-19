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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 2; // Sharing
			break;
		default:
			break;
	}

	return 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"Sharing";
			break;
		default:
			break;
	}
	return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"extrasCell"];
	
	if (nil == cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"extrasCell"] autorelease];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
//		cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
//		cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	}
	
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Share";
			break;
		case 1:
			cell.textLabel.text = @"Share link";
			break;
		default:
			cell.textLabel.text = @"";
			break;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	switch (indexPath.section) {
		case 0:
		{
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
			break;
		}
		default:
			break;
	}
}




@end
