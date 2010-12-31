//
//  JavaZone2011Controller.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "JavaZone2011Controller.h"
#import "FlurryAPI.h"

@implementation JavaZone2011Controller

@synthesize movie;
@synthesize details;

- (void)viewWillAppear:(BOOL)animated {
	[FlurryAPI logEvent:@"Showing 2011"];

	[details setBackgroundColor:[UIColor clearColor]];
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

- (void)viewDidLoad {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seenVideo"] == NO) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"seenVideo"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	
		[self playVideo:self];
	} else {
		[details setAlpha:1.0];
	}
}


- (void)playVideo:(id)sender {
	[FlurryAPI logEvent:@"Playing Movie"];
	
	// iOS 4 only	NSURL *movieUrl = [[NSBundle mainBundle] URLForResource:@"jz11_you_are_invited.mp4" withExtension:nil];
	NSURL *movieUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"jz11_you_are_invited" ofType:@"mp4"]];
	
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
	[FlurryAPI logEvent:@"Stopping Movie"];

	[self dismissModalViewControllerAnimated:YES];
	[movie.moviePlayer stop];
	[movie release];
	movie = NULL;
	
	[[NSNotificationCenter defaultCenter]
	 removeObserver: self
	 name: MPMoviePlayerPlaybackDidFinishNotification
	 object: nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:3.0];
	[details setAlpha:1.0];
	[UIView commitAnimations];
}

@end
