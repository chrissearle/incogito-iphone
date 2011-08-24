//
//  SessionTableViewCell.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "SessionTableViewCell.h"

@implementation SessionTableViewCell

@synthesize favouriteImage;
@synthesize levelImage;

@synthesize sessionLabel;
@synthesize speakerLabel;

@synthesize iconBarView;

@synthesize jzId;

- (void)dealloc {
    [favouriteImage release];
    [levelImage release];
    [sessionLabel release];
    [speakerLabel release];
    [iconBarView release];
    [jzId release];
    
    [super dealloc];
}

@end
