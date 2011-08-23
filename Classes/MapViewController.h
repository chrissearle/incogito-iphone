//
//  MapViewController.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) BOOL followingLocation;

- (void) closeModalViewController:(id)sender;

- (IBAction)locationButton:(id)sender;
- (IBAction)clubZoomButton:(id)sender;
- (IBAction)typeSegmentSelected:(id)sender;

- (void) goToDefaultLocationAndZoom;

@end
