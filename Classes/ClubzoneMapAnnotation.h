//
//  ClubzonieMapAnnotation.h
//  Untitled
//
//  Created by Chris Searle on 08.08.10.
//  Copyright 2010 Itera Consulting. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface ClubzoneMapAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D _coordinate;

	NSString *_title;
	NSString *_subtitle;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title andSubtitle:(NSString *)subtitle;

@end
