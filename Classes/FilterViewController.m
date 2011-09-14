//
//  FilterViewController.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "FilterViewController.h"
#import "IncogitoAppDelegate.h"
#import "SectionSessionHandler.h"
#import "JavaZonePrefs.h"

@implementation FilterViewController

@synthesize listSelector;
@synthesize levelSelector;
@synthesize picker;
@synthesize labels;
@synthesize appDelegate;
@synthesize viewShouldRefreshDelegate;
@synthesize initialized;

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

    self.initialized = NO;
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
   
    [self.levelSelector removeAllSegments];
    [self.levelSelector insertSegmentWithTitle:@"All" atIndex:0 animated:NO];
    [self.levelSelector insertSegmentWithImage:[self getImageForLevel:@"Introductory"] atIndex:1 animated:NO];
    [self.levelSelector insertSegmentWithImage:[self getImageForLevel:@"Intermediate"] atIndex:2 animated:NO];
    [self.levelSelector insertSegmentWithImage:[self getImageForLevel:@"Advanced"] atIndex:3 animated:NO];
    
    [self.levelSelector setSelectedSegmentIndex:0];
    
    [self setLabels:[[self.appDelegate sectionSessionHandler] getUniqueLabels]];
    
	// Set picker index
	NSString *savedKey = [JavaZonePrefs labelFilter];
	
	NSArray *values = [[self.labels allValues] sortedArrayUsingSelector:@selector(compare:)];
	
	int index = 0;
	if ([values containsObject:savedKey]) {
		NSArray *sortedValues = [values sortedArrayUsingSelector:@selector(compare:)];
		index = [sortedValues indexOfObject:savedKey] + 1;
	}
	[self.picker selectRow:index inComponent:0 animated:YES];
    
    
    
    NSString *savedListKey = [JavaZonePrefs listFilter];

    int selectedListIndex = 0;
    
    for (int i = 0; i < self.listSelector.numberOfSegments; i++) {
        if ([savedListKey isEqualToString:[self.listSelector titleForSegmentAtIndex:i]]) {
            selectedListIndex = i;
        }
    }

    self.listSelector.selectedSegmentIndex = selectedListIndex;
    
    NSString *savedLevelFilter = [JavaZonePrefs levelFilter];

    AppLog(@"Init level filter to %@", savedLevelFilter);
    
    if ([savedLevelFilter isEqualToString:@"All"]) {
        self.levelSelector.selectedSegmentIndex = 0;
    }
    if ([savedLevelFilter isEqualToString:@"Introductory"]) {
        self.levelSelector.selectedSegmentIndex = 1;
    }
    if ([savedLevelFilter isEqualToString:@"Intermediate"]) {
        self.levelSelector.selectedSegmentIndex = 2;
    }
    if ([savedLevelFilter isEqualToString:@"Advanced"]) {
        self.levelSelector.selectedSegmentIndex = 3;
    }
    
    self.initialized = YES;
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

- (IBAction) done:(id)sender {
    [self.viewShouldRefreshDelegate refeshView:YES withFull:NO];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction) listSelected:(id)selector {
    if (self.initialized == YES) {
        AppLog(@"List selected: %d", [self.listSelector selectedSegmentIndex]);
    
        [JavaZonePrefs setListFilter:[self.listSelector titleForSegmentAtIndex:[self.listSelector selectedSegmentIndex]]];
    }
}

- (IBAction) levelSelected:(id)selector {
    if (self.initialized == YES) {
        AppLog(@"Level selected: %d", [self.levelSelector selectedSegmentIndex]);
        
        switch ([self.levelSelector selectedSegmentIndex]) {
            case 0:
                [JavaZonePrefs setLevelFilter:@"All"];
                break;
            case 1:
                [JavaZonePrefs setLevelFilter:@"Introductory"];
                break;
            case 2:
                [JavaZonePrefs setLevelFilter:@"Intermediate"];
                break;
            case 3:
                [JavaZonePrefs setLevelFilter:@"Advanced"];
                break;
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [[self.labels allKeys] count] + 1;
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
				NSArray *keys = [self.labels keysSortedByValueUsingSelector:@selector(compare:)];
				[label setText:[self.labels objectForKey:[keys objectAtIndex:(row - 1)]]];
			}
		}
		
		if ([subview class] == [UIImageView class]) {
			UIImageView *image = (UIImageView *)subview;
			if (row == 0) {
				[image setImage:[UIImage imageNamed:@"all.png"]];
			} else {
				NSArray *keys = [self.labels keysSortedByValueUsingSelector:@selector(compare:)];
				
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	// Read current picker setting
	NSArray *values = [[self.labels allValues] sortedArrayUsingSelector:@selector(compare:)];
	
	NSString *label = @"All";
	
	if (row > 0) {
		label = [values objectAtIndex:(row - 1)];
	}
    
	// Store pref
	[JavaZonePrefs setLabelFilter:label];
	
	[FlurryAnalytics logEvent:@"Filtered" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          label,
                                                          @"Label",
                                                          nil]];
}



@end
