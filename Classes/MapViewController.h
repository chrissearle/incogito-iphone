//
//  MapViewController.h
//  Untitled
//
//  Created by Chris Searle on 08.08.10.
//  Copyright 2010 Itera Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;
	
}

@property (nonatomic, retain) MKMapView *mapView;

- (void) closeModalViewController:(id)sender;

@end
