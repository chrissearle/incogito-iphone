//
//  ClubzonieMapAnnotation.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
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
