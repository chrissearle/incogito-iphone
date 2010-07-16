//
//  DetailedSessionViewController.m
//  incogito
//
//  Created by Markuz Lindgren on 15.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "DetailedSessionViewController.h"

@implementation DetailedSessionViewController

@synthesize session;
@synthesize sessionTitle;
@synthesize sessionLocation;
@synthesize details;
@synthesize level;
@synthesize levelImage;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSDateFormatter *startFormatter = [[NSDateFormatter alloc] init];
	[startFormatter setDateFormat:@"hh:mm"];
	NSDateFormatter *endFormatter = [[NSDateFormatter alloc] init];
	[endFormatter setDateFormat:@"hh:mm"];
	
	[sessionTitle setText:session.title];
	[sessionLocation setText:[NSString stringWithFormat:@"%@ - %@ in room %@",
							  [startFormatter stringFromDate:[session startDate]],
							  [endFormatter stringFromDate:[session endDate]],
							  [session room]]];

	[details setText:[self removeHtmlTags:session.detail]];
	
	[level setText:[session level]];
	
	[levelImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [session level]]]];
	
	[startFormatter release];
	[endFormatter release];
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

- (NSString *)removeHtmlTags:(NSString *)textWithTags {
    NSScanner *theScanner;
    NSString *text = nil;
	
    theScanner = [NSScanner scannerWithString:textWithTags];
	
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
        [theScanner scanUpToString:@">" intoString:&text];
        textWithTags = [textWithTags stringByReplacingOccurrencesOfString:
				[ NSString stringWithFormat:@"%@>", text]
											   withString:@""];
		
    }
	// remove line break
	textWithTags = [textWithTags stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	
    return textWithTags;
}


@end
