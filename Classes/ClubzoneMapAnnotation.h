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
	NSString *_name;
	NSString *_entertainment;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *entertainment;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andName:(NSString *)name andEntertainment:(NSString *)entertainment;

@end
