//
//  ClubzonieMapAnnotation.m
//  Untitled
//
//  Created by Chris Searle on 08.08.10.
//  Copyright 2010 Itera Consulting. All rights reserved.
//

#import "ClubzoneMapAnnotation.h"


@implementation ClubzoneMapAnnotation

@synthesize coordinate=_coordinate;
@synthesize name=_name;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andName:(NSString *)name{
	self = [super init];
	if (self != nil) {
		_coordinate = coordinate;
		_name = name;
	}
	return self;
}


- (NSString *)title {
	return _name;
}

@end
