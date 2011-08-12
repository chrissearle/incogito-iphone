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
	
	NSString *_pin;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *pin;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title andSubtitle:(NSString *)subtitle andPinIcon:(NSString *)pinIcon;

@end
