//
//  FilterViewController.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "FilterViewController.h"
#import "IncogitoAppDelegate.h"
#import "SectionSessionHandler.h"

@implementation FilterViewController

@synthesize listSelector;
@synthesize levelSelector;
@synthesize picker;
@synthesize labels;
@synthesize appDelegate;

- (void)dealloc
{
    [picker release];
    [labels release];
    [listSelector release];
    [levelSelector release];
    [appDelegate release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (UIImage *)getImageForLevel:(NSString *) level {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:@"levelIcons"],level];
	
	NSData *data1 = [NSData dataWithContentsOfFile:pngFilePath];
	
	UIImage *imageFile = [UIImage imageWithData:data1];
    
    return imageFile;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appDelegate = [[UIApplication sharedApplication] delegate];
   
    [self.levelSelector removeAllSegments];
    [self.levelSelector insertSegmentWithTitle:@"All" atIndex:0 animated:NO];
    [self.levelSelector insertSegmentWithImage:[self getImageForLevel:@"Introductory"] atIndex:1 animated:NO];
    [self.levelSelector insertSegmentWithImage:[self getImageForLevel:@"Intermediate"] atIndex:2 animated:NO];
    [self.levelSelector insertSegmentWithImage:[self getImageForLevel:@"Advanced"] atIndex:3 animated:NO];
    
    [self.levelSelector setSelectedSegmentIndex:0];
    
    [self setLabels:[[self.appDelegate sectionSessionHandler] getUniqueLabels]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.listSelector = nil;
    self.levelSelector = nil;
    self.picker = nil;
    self.labels = nil;
    self.appDelegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction) done:(id)selector {
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [[[self labels] allKeys] count] + 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	if (nil == view) {
		view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 230, 32)] autorelease];
		
		UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 11.0, 10, 10)];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, 0.0, 198, 32)];
		
		[label setBackgroundColor:[UIColor clearColor]];
		[label setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
		
		[view addSubview:image];
		[view addSubview:label];
		
		[image release];
		[label release];
	}
	
	for (UIView *subview in view.subviews) {
		if ([subview class] == [UILabel class]) {
			UILabel *label = (UILabel *)subview;
			if (row == 0) {
				[label setText:@"All"];
			} else {
				NSArray *keys = [[self.labels allKeys] sortedArrayUsingSelector:@selector(compare:)];
				[label setText:[self.labels objectForKey:[keys objectAtIndex:(row - 1)]]];
			}
		}
		
		if ([subview class] == [UIImageView class]) {
			UIImageView *image = (UIImageView *)subview;
			if (row == 0) {
				[image setImage:[UIImage imageNamed:@"all.png"]];
			} else {
				NSArray *keys = [[self.labels allKeys] sortedArrayUsingSelector:@selector(compare:)];
				
				NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
				
				NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:@"labelIcons"],[keys objectAtIndex:(row - 1)]];
				
				NSData *data1 = [NSData dataWithContentsOfFile:pngFilePath];
                
				UIImage *imageFile;
				
				if (nil == data1) {
					AppLog(@"File not found %@", pngFilePath);
					
					imageFile = [UIImage imageNamed:@"all.png"];
				} else {
					imageFile = [UIImage imageWithData:data1];
				}
				
				[image setImage:imageFile];
			}
		}
	}
	
	return view;
}



@end
