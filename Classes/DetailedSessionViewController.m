//
//  DetailedSessionViewController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "DetailedSessionViewController.h"
#import "JZSession.h"
#import "JZSessionBio.h"
#import "SectionSessionHandler.h"
#import "IncogitoAppDelegate.h"
#import "ExtrasController.h"
#import "SHK.h"
#import "JavaZonePrefs.h"

@implementation DetailedSessionViewController

@synthesize sessionLocation;
@synthesize details;
@synthesize level;
@synthesize levelImage;
@synthesize handler;
@synthesize appDelegate;
@synthesize session;
@synthesize checkboxButton;
@synthesize checkboxSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.appDelegate = [[UIApplication sharedApplication] delegate];
	self.handler = [appDelegate sectionSessionHandler];
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	const CGFloat myColor[] = {0.67, 0.67, 0.67, 1.0};
	CGColorRef colour = CGColorCreate(rgb, myColor);
	CGColorSpaceRelease(rgb);
	
	[[self.details layer] setCornerRadius:8.0f];
	[[self.details layer] setMasksToBounds:YES];
	[[self.details layer] setBorderWidth:1.0];
	[[self.details layer] setBorderColor:colour];
	
	CGColorRelease(colour);
	
	[self displaySession];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[FlurryAPI logEvent:@"Showing detail view" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															   [self.session title],
															   @"Title",
															   [self.session jzId],
															   @"ID", 
															   nil]];
}

- (void)displaySession {
    self.checkboxSelected = NO;
	
	NSDateFormatter *startFormatter = [[NSDateFormatter alloc] init];
	[startFormatter setDateFormat:@"hh:mm"];
	NSDateFormatter *endFormatter = [[NSDateFormatter alloc] init];
	[endFormatter setDateFormat:@"hh:mm"];
	
	[self.sessionLocation setText:[NSString stringWithFormat:@"%@ - %@ in room %@",
							  [startFormatter stringFromDate:[self.session startDate]],
							  [endFormatter stringFromDate:[self.session endDate]],
							  [self.session room]]];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	[self.details loadHTMLString:[self buildPage:[self.session detail]
								  withTitle:[self.session title]
							withSpeakerInfo:[self buildSpeakersSection:[self.session speakers]]
							  andLabelsInfo:[self buildLabelsSection:[self.session labels]]]
					baseURL:baseURL];
	
	[self.level setText:[self.session level]];
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:@"levelIcons"],[self.session level]];
	
	NSData *data1 = [NSData dataWithContentsOfFile:pngFilePath];
	
	UIImage *imageFile = [UIImage imageWithData:data1];
	
	[self.levelImage setImage:imageFile];
	
	[startFormatter release];
	[endFormatter release];
	
	if ([self.session userSession]) {
		self.checkboxSelected = YES;
		[self.checkboxButton setSelected:YES];
	} else {
		[self.checkboxButton setSelected:NO];
	}
	
	self.title = [self.session title];
	
	UIBarButtonItem *button = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showExtras:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = button;
}

- (void)reloadSession {
	self.session = [self.handler getSessionForJZId:[self.session jzId]];
	
	[self displaySession];
}

- (IBAction)checkboxButton:(id)sender{
	if (self.checkboxSelected == NO){
		[self.checkboxButton setSelected:YES];
		self.checkboxSelected = YES;
		[self.handler setFavouriteForSession:session withBoolean:YES];
	} else {
		[self.checkboxButton setSelected:NO];
		self.checkboxSelected = 0;
		[self.handler setFavouriteForSession:session withBoolean:NO];
	}
	
	[self.appDelegate refreshViewData];
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
    [session release];
    [details release];
    [sessionLocation release];
    [level release];
    [levelImage release];
    [handler release];
    [appDelegate release];
    [checkboxButton release];

    [super dealloc];
}

- (NSString *)buildSpeakersSection:(NSSet *)speakers {
	NSMutableString *result = [[NSMutableString alloc] init];
	
	for (JZSessionBio *speaker in speakers) {
		[result appendString:[NSString stringWithFormat:@"<h3>%@</h3>", [speaker name]]];
		
        if ([JavaZonePrefs showBioPic]) {
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:@"bioIcons"],[speaker name]];
		
            NSFileManager *fileManager = [NSFileManager defaultManager];

            if ([fileManager fileExistsAtPath:pngFilePath]) {
                NSError *fileError = nil;
                
                NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:pngFilePath error:&fileError];
                
                if (fileError != nil) {
                    AppLog(@"Got file error reading file attributes for file %@", pngFilePath);
                } else {
                    if ([fileAttributes fileSize] > 0) {
                        [result appendString:[NSString stringWithFormat:@"<img src='file://%@' width='50px' style='float: left; margin-right: 3px; margin-bottom: 3px'/>", pngFilePath]];
                    } else {
                        AppLog(@"Empty bioPic %@", pngFilePath);
                    }
                }
            }
        }
        
		[result appendString:[speaker bio]];
	}

	NSString *speakerSection = [NSString stringWithString:result];
	
	[result release];
	
	return speakerSection;
}

- (NSString *)buildLabelsSection:(NSSet *)labels {
	if (nil == labels || [labels count] == 0) {
		return @"";
	} else {
		NSMutableString *result = [[NSMutableString alloc] init];
		
		[result appendString:@"<h2>Labels</h2>"];
		
		[result appendString:@"<ul class=\"labels\">"];
		
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

		NSSortDescriptor * titleDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES] autorelease];
		
		NSArray * descriptors = [NSArray arrayWithObjects:titleDescriptor, nil];
		
		for (JZLabel *label in [[labels allObjects] sortedArrayUsingDescriptors:descriptors]) {
			NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:@"labelIcons"],[label jzId]];
			
			[result appendFormat:@"<li style=\"list-style-image: url('file://%@')\">%@</li>", pngFilePath, [label title]];
		}
		
		[result appendString:@"</ul>"];
		
		NSString *labelsSection = [NSString stringWithString:result];
		[result release];
		
		return labelsSection;
	}
}

- (NSString *)buildPage:(NSString *)content withTitle:(NSString *)title withSpeakerInfo:(NSString *)speakerInfo andLabelsInfo:(NSString *)labelsInfo {
	NSString *page = [NSString stringWithFormat:@""
					  "<html>"
					  "<head>"
					  "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\"/>"
                      "<meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0;'>"
					  "</head>"
					  "<body>"
					  "<h1>%@</h1>"
					  "%@"
					  "%@"
					  "<h2>Speakers</h2>"
					  "%@"
					  "</body>"
					  "</html>",
					  title,
					  content,
					  labelsInfo,
					  speakerInfo];
	
	return page;
}

- (void) showExtras:(id)sender {
	ExtrasController *controller = [[ExtrasController alloc] initWithNibName:@"DetailedViewExtras" bundle:[NSBundle mainBundle]];
	controller.session = self.session;
	
	[[self navigationController] pushViewController:controller animated:YES];
	[controller release], controller = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
