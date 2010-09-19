//
//  JavaZone2011Controller.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "JavaZone2011Controller.h"
#import <QuartzCore/QuartzCore.h>

@implementation JavaZone2011Controller

- (void)viewDidLoad {
    [super viewDidLoad];

	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	const CGFloat myColor[] = {0.129, 0.129, 0.129, 1.0};
	CGColorRef colour = CGColorCreate(rgb, myColor);
	CGColorSpaceRelease(rgb);
	
	[[self view] setBackgroundColor:[[[UIColor alloc] initWithCGColor:colour] autorelease]];

	CGColorRelease(colour);
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


@end
