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
#import "FlurryAPI.h"
#import "SHK.h"
#import "JavaZonePrefs.h"
#import "VideoMapper.h"

@implementation DetailedSessionViewController

@synthesize sessionLocation;
@synthesize details;
@synthesize level;
@synthesize levelImage;
@synthesize handler;
@synthesize appDelegate;
@synthesize movie;
@synthesize feedbackView;
@synthesize shareView;

- (void)redrawForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGRect frame = details.frame;
        if (UIDeviceOrientationIsLandscape(interfaceOrientation)) {
            frame.size.width = 1004;
            frame.size.height = 300;
        } else {
            frame.size.width = 745;
            frame.size.height = 562;
        }
        details.frame = frame;

        CGRect feedbackFrame = feedbackView.frame;
        feedbackFrame.origin.x = ((self.view.frame.size.width - feedbackFrame.size.width) / 2);
        feedbackView.frame = feedbackFrame;

        CGRect shareFrame = shareView.frame;
        shareFrame.origin.x = ((self.view.frame.size.width - shareFrame.size.width) / 2);
        shareView.frame = shareFrame;
    }
    
    [super redrawForOrientation:interfaceOrientation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setAppDelegate:[[UIApplication sharedApplication] delegate]];
	handler = [appDelegate sectionSessionHandler];
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	const CGFloat myColor[] = {0.67, 0.67, 0.67, 1.0};
	CGColorRef colour = CGColorCreate(rgb, myColor);
	CGColorSpaceRelease(rgb);
	
	[[details layer] setCornerRadius:8.0f];
	[[details layer] setMasksToBounds:YES];
	[[details layer] setBorderWidth:1.0];
	[[details layer] setBorderColor:colour];
	
	CGColorRelease(colour);
	
	[self displaySession];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[FlurryAPI logEvent:@"Showing detail view" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															   [session title],
															   @"Title",
															   [session jzId],
															   @"ID", 
															   nil]];

    [self redrawForOrientation:[self interfaceOrientation]];
}

- (void)displaySession {
	checkboxSelected = 0;
	
	NSDateFormatter *startFormatter = [[NSDateFormatter alloc] init];
	[startFormatter setDateFormat:@"hh:mm"];
	NSDateFormatter *endFormatter = [[NSDateFormatter alloc] init];
	[endFormatter setDateFormat:@"hh:mm"];
	
	[sessionLocation setText:[NSString stringWithFormat:@"%@ - %@ in room %@",
							  [startFormatter stringFromDate:[session startDate]],
							  [endFormatter stringFromDate:[session endDate]],
							  [session room]]];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	[details loadHTMLString:[self buildPage:[session detail]
								  withTitle:[session title]
							withSpeakerInfo:[self buildSpeakersSection:[session speakers]]
							  andLabelsInfo:[self buildLabelsSection:[session labels]]]
					baseURL:baseURL];
	
	[level setText:[session level]];
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:@"levelIcons"],[session level]];
	
	NSData *data1 = [NSData dataWithContentsOfFile:pngFilePath];
	
	UIImage *imageFile = [UIImage imageWithData:data1];
	
	[levelImage setImage:imageFile];
	
	[startFormatter release];
	[endFormatter release];
	
	if ([session userSession]) {
		checkboxSelected = 1;
		[checkboxButton setSelected:YES];
	} else {
		[checkboxButton setSelected:NO];
	}
	
	self.title = [session title];
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		UIBarButtonItem *button = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showExtras:)] autorelease];
	
		self.navigationItem.rightBarButtonItem = button;
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSString *streamingUrl = [VideoMapper streamingUrlForSession:[session jzId]];
    
        if (streamingUrl == nil) {
            [videoButton setEnabled:NO];
            [videoLabel setText:@"Video not available"];
        } else {
            [videoButton setEnabled:YES];
            [videoLabel setText:@"Video streams can take a while to start"];
        }
    }
}

- (void)reloadSession {
	session = [handler getSessionForJZId:[session jzId]];
	
	[self displaySession];
}

- (IBAction)checkboxButton:(id)sender{
	if (checkboxSelected == 0){
		[checkboxButton setSelected:YES];
		checkboxSelected = 1;
		[handler setFavouriteForSession:session withBoolean:YES];
	} else {
		[checkboxButton setSelected:NO];
		checkboxSelected = 0;
		[handler setFavouriteForSession:session withBoolean:NO];
	}
	
	[appDelegate refreshViewData];
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

- (NSString *)buildSpeakersSection:(NSSet *)speakers {
	NSMutableString *result = [[NSMutableString alloc] init];
	
	for (JZSessionBio *speaker in speakers) {
		[result appendString:[NSString stringWithFormat:@"<h3>%@</h3>", [speaker name]]];
		
        if ([JavaZonePrefs showBioPic]) {
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:@"bioIcons"],[speaker name]];
		
            NSFileManager *fileManager = [NSFileManager defaultManager];

            if ([fileManager fileExistsAtPath:pngFilePath]) {
                [result appendString:[NSString stringWithFormat:@"<img src='file://%@' width='50px' style='float: left; margin-right: 3px; margin-bottom: 3px'/>", pngFilePath]];
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
	controller.session = session;
	
	[[self navigationController] pushViewController:controller animated:YES];
	[controller release], controller = nil;
}

- (IBAction)shareText:(id)sender {
	NSString *text = [NSString stringWithFormat:@"#JavaZone - %@", [session title]];
	
	SHKItem *item = [SHKItem text:text];
	
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showInView:[self view]];
}

- (IBAction)shareLink:(id)sender {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://javazone.no/incogito10/events/JavaZone%202010/sessions/%@", [session title]]];
	
	SHKItem *item = [SHKItem URL:url title:[session title]];

	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showInView:[self view]];
}

- (IBAction)playVideo:(id)sender {
    NSString *streamingUrl = [VideoMapper streamingUrlForSession:[session jzId]];
    
    [FlurryAPI logEvent:[NSString stringWithFormat:@"Streaming movie %@", streamingUrl]];
    
    NSURL *movieUrl = [NSURL URLWithString:streamingUrl];
    
    movie = [[MPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
    
    [self presentModalViewController:movie animated:YES];
    
    // Movie playback is asynchronous, so this method returns immediately.
    [movie.moviePlayer play];
    
    // Register for the playback finished notification
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(endVideo:)
     name: MPMoviePlayerPlaybackDidFinishNotification
     object: movie.moviePlayer];
  
}

- (void)endVideo:(NSNotification*) aNotification {
    [FlurryAPI logEvent:@"Stopping stream"];
    
	[self dismissModalViewControllerAnimated:YES];
	[movie.moviePlayer stop];
	[movie release];
	movie = NULL;
	
	[[NSNotificationCenter defaultCenter]
	 removeObserver: self
	 name: MPMoviePlayerPlaybackDidFinishNotification
	 object: nil];

}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                         duration:(NSTimeInterval)duration {
    
    [self redrawForOrientation:toInterfaceOrientation];
}

@end
