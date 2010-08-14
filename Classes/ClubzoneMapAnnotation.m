//
//  ClubzonieMapAnnotation.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "ClubzoneMapAnnotation.h"


@implementation ClubzoneMapAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate=_coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title andSubtitle:(NSString *)subtitle {
	self = [super init];
	if (self != nil) {
		_coordinate = coordinate;
		self.title = title;
		self.subtitle = subtitle;
	}
	return self;
}

@end
