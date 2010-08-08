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
}

@property (nonatomic, retain) NSString *name;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andName:(NSString *)name;

@end
