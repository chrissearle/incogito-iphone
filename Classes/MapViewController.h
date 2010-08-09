//
//  MapViewController.h
//  Untitled
//
//  Created by Chris Searle on 08.08.10.
//  Copyright 2010 Itera Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;
	IBOutlet UIButton *locationToggle;
	BOOL followingLocation;
}

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UIButton *locationToggle;


- (void) closeModalViewController:(id)sender;
- (IBAction)locationButton:(id)sender;
- (void) goToDefaultLocationAndZoom;

@end
