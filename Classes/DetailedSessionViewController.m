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
@synthesize startDate;
@synthesize endDate;
@synthesize details;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
	
	[sessionTitle setText:session.title];
	[startDate setText:[formatter stringFromDate:session.startDate]];
	[endDate setText:[formatter stringFromDate:session.endDate]];
	[details setText:[self removeHtmlTags:session.detail]];
	
	[formatter release];
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
