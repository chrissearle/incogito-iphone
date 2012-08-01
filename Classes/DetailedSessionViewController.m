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
#import "FeedbackController.h"
#import "SHK.h"
#import "JavaZonePrefs.h"
#import "VideoMapper.h"
#import "FeedbackAvailability.h"

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
@synthesize feedbackButton;
@synthesize videoButton;
@synthesize shareButton;
@synthesize feedbackAvailability;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.appDelegate = [[UIApplication sharedApplication] delegate];
	self.handler = [appDelegate sectionSessionHandler];
    self.feedbackAvailability = [[[FeedbackAvailability alloc] initWithUrl:[NSURL URLWithString:[JavaZonePrefs feedbackUrl]]] autorelease];
    
	[self displaySession];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[FlurryAnalytics logEvent:@"Showing detail view" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															   [self.session title],
															   @"Title",
															   [self.session jzId],
															   @"ID", 
															   nil]];
}

- (void) prepareButton:(CALayer *)layer {
    [layer setCornerRadius:8.0f];
    [layer setMasksToBounds:YES];
    [layer setBackgroundColor:[[UIColor blackColor] CGColor]];
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
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
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

    [self prepareButton:[shareButton layer]];
    [self prepareButton:[videoButton layer]];
    [self prepareButton:[feedbackButton layer]];

    dispatch_queue_t dqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(dqueue, ^{
        VideoMapper *mapper = [[[VideoMapper alloc] init] autorelease];
        [mapper download];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [mapper streamingUrlForSession:[self.session jzId]];
        });
    });

    dispatch_async(dqueue, ^{
        [self.feedbackAvailability downloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.feedbackAvailability populateDict];
        });
    });
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
    
    self.details = nil;
    self.sessionLocation = nil;
    self.level = nil;
    self.levelImage = nil;
    self.checkboxButton = nil;
    self.videoButton = nil;
    self.shareButton = nil;
    self.feedbackButton = nil;
    self.feedbackAvailability = nil;
    
    self.appDelegate = nil;
    self.handler = nil;
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
    [shareButton release];
    [videoButton release];
    [feedbackButton release];
    [feedbackAvailability release];
    
    [super dealloc];
}

- (NSString *)buildSpeakersSection:(NSSet *)speakers {
	NSMutableString *result = [[NSMutableString alloc] init];
	
	for (JZSessionBio *speaker in speakers) {
		[result appendString:[NSString stringWithFormat:@"<h3>%@</h3>", [speaker name]]];
		
        if ([JavaZonePrefs showBioPic]) {
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
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
		
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (IBAction)share:(id)sender {
    SHKItem *item = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"http://javazone.no/incogito10/events/JavaZone%%202011/sessions#%@", [self.session jzId]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSString *titleString = [NSString stringWithFormat:@"#JavaZone - %@", [self.session title]];
    item = [SHKItem URL:url title:titleString];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // Display the action sheet
    [actionSheet showInView:[self view]];
}

- (IBAction)feedback:(id)sender {
    if ([self.feedbackAvailability isFeedbackAvailableForSession:[self.session jzId]]) {
        FeedbackController *controller = [[FeedbackController alloc] initWithNibName:@"Feedback" bundle:[NSBundle mainBundle]];
        controller.session = self.session;
        controller.feedbackURL = [self.feedbackAvailability feedbackUrlForSession:[self.session jzId]];
    
        [[self navigationController] pushViewController:controller animated:YES];
        [controller release], controller = nil;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback" message:@"Feedback can only be given once the session is nearly finished" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)video:(id)sender {
    VideoMapper *mapper = [[[VideoMapper alloc] init] autorelease];
    
    NSString *streamingUrl = [mapper streamingUrlForSession:[self.session jzId]];
    
    if (streamingUrl == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video" message:@"Session video not yet available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        [FlurryAnalytics logEvent:@"Streaming Movie" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [self.session jzId],
                                                                 @"ID",
                                                                 [self.session title],
                                                                 @"Title",
                                                                 streamingUrl,
                                                                 @"URL",
                                                                 nil]];
    
        NSURL *movieUrl = [NSURL URLWithString:streamingUrl];
    
        [[UIApplication sharedApplication] openURL:movieUrl];
    }
}

@end
