//
//  DetailedSessionViewController.m
//  incogito
//
//  Created by Markuz Lindgren on 15.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "DetailedSessionViewController.h"
#import "JZSession.h"
#import "JZSessionBio.h"
#import "SectionSessionHandler.h"
#import "IncogitoAppDelegate.h"

@implementation DetailedSessionViewController

@synthesize session;
@synthesize sessionTitle;
@synthesize sessionLocation;
@synthesize details;
@synthesize level;
@synthesize levelImage;
@synthesize handler;
@synthesize appDelegate;

- (void)viewDidLoad {
	checkboxSelected = 0;
	
    [super viewDidLoad];
	
	[self setAppDelegate:[[UIApplication sharedApplication] delegate]];
	
	handler = [appDelegate sectionSessionHandler];
	
	NSDateFormatter *startFormatter = [[NSDateFormatter alloc] init];
	[startFormatter setDateFormat:@"hh:mm"];
	NSDateFormatter *endFormatter = [[NSDateFormatter alloc] init];
	[endFormatter setDateFormat:@"hh:mm"];
	
	[sessionTitle setText:session.title];
	[sessionLocation setText:[NSString stringWithFormat:@"%@ - %@ in room %@",
							  [startFormatter stringFromDate:[session startDate]],
							  [endFormatter stringFromDate:[session endDate]],
							  [session room]]];

	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];

	[details loadHTMLString:[self buildPage:[session detail]
							withSpeakerInfo:[self buildSpeakersSection:[session speakers]]
							  andLabelsInfo:[self buildLabelsSection:[session labels]]]
					baseURL:baseURL];
	
	[level setText:[session level]];
	
	[levelImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [session level]]]];
	
	[startFormatter release];
	[endFormatter release];
	
	if ([session userSession]) {
		checkboxSelected = 1;
		[checkboxButton setSelected:YES];
	}
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
	
	[appDelegate refreshFavouriteViewData];
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

- (void) closeModalViewController:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (NSString *)buildSpeakersSection:(NSSet *)speakers {
	NSMutableString *result = [[NSMutableString alloc] init];
	
	for (JZSessionBio *speaker in speakers) {
		NSString *speakerLine = [NSString stringWithFormat:@"<h3>%@</h3>%@", [speaker name], [speaker bio]];
		
		[result appendString:speakerLine];
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

		[result appendString:@"<ul>"];
		
		for (JZLabel *label in labels) {
			[result appendFormat:@"<li class=\"label-%@\">%@</li>", [label jzId], [label title]];
		}
		
		[result appendString:@"</ul>"];
		
		NSString *labelsSection = [NSString stringWithString:result];
		[result release];

		return labelsSection;
	}
}

- (NSString *)buildPage:(NSString *)content withSpeakerInfo:(NSString *)speakerInfo andLabelsInfo:(NSString *)labelsInfo {
	NSString *page = [NSString stringWithFormat:@""
					  "<html>"
					  "<head>"
					  "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\"/>"
					  "</head>"
					  "<body>"
					  "%@"
					  "%@"
					  "<h2>Speakers</h2>"
					  "%@"
					  "</body>"
					  "</html>",
					  content,
					  labelsInfo,
					  speakerInfo];
	
	return page;
}

@end
