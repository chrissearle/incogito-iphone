    //
//  MapViewController.m
//  Untitled
//
//  Created by Chris Searle on 08.08.10.
//  Copyright 2010 Itera Consulting. All rights reserved.
//

#import "MapViewController.h"

#import "ClubzoneMapAnnotation.h"

@implementation MapViewController

@synthesize mapView;
@synthesize locationToggle;
@synthesize clubZoom;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	followingLocation = NO;
	
    [super viewDidLoad];

	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	const CGFloat myColor[] = {0.62, 0.62, 0.62, 1.0};
	CGColorRef colour = CGColorCreate(rgb, myColor);
	CGColorSpaceRelease(rgb);
	
	[[locationToggle layer] setCornerRadius:8.0f];
	[[locationToggle layer] setMasksToBounds:YES];
	[locationToggle setBackgroundColor:[UIColor whiteColor]];
	[[locationToggle layer] setBorderWidth:1.0];
	[[locationToggle layer] setBorderColor:colour];

	[[clubZoom layer] setCornerRadius:8.0f];
	[[clubZoom layer] setMasksToBounds:YES];
	[clubZoom setBackgroundColor:[UIColor whiteColor]];
	[[clubZoom layer] setBorderWidth:1.0];
	[[clubZoom layer] setBorderColor:colour];

	CGColorRelease(colour);
	
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.912958,10.754421}
																	  andName:@"JavaZone"
															 andEntertainment:@"Oslo Spektrum"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.91291,10.761501}
																	  andName:@"Gloria Flames"
															 andEntertainment:@"Blotsbrødre - A tribute to norwegian rock"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.9130091,10.760917}
																	  andName:@"Ivars Kro"
															 andEntertainment:@"Piano Bar"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.913128,10.760233}
																	  andName:@"Dattera til Hagen"
															 andEntertainment:@"Stand-Up"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.913696,10.756906}
																	  andName:@"Cafe Con Bar"
															 andEntertainment:@"DJ Mario"] autorelease]];

	mapView.showsUserLocation = YES;
	
	[self.mapView.userLocation addObserver:self  
								forKeyPath:@"location"  
								   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
								   context:NULL];
	
	[self goToDefaultLocationAndZoom];
}

-(void)observeValueForKeyPath:(NSString *)keyPath  
                     ofObject:(id)object  
                       change:(NSDictionary *)change  
                      context:(void *)context {  
	
    if (followingLocation) {
		[mapView setCenterCoordinate:[[[self.mapView userLocation] location] coordinate] animated:YES];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation {
	if ([annotation class] == MKUserLocation.class) {
        return nil;
    }
	
	MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mv dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
	
	if(pinView == nil) {
		pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"] autorelease];
		
		pinView.pinColor = MKPinAnnotationColorPurple;
		pinView.animatesDrop = YES;
		pinView.canShowCallout = YES;
	} else {
		pinView.annotation = annotation;
	}
	
	return pinView;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mapView.userLocation removeObserver:self forKeyPath:@"location"];
    [super dealloc];
}

- (void) closeModalViewController:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)locationButton:(id)sender {
	followingLocation = !followingLocation;
	
	[locationToggle setSelected:followingLocation];
	
	if (followingLocation == NO) {
		[locationToggle setBackgroundColor:[UIColor whiteColor]];
	} else {
		[locationToggle setBackgroundColor:[UIColor blueColor]];
		mapView.region = MKCoordinateRegionMakeWithDistance([[[self.mapView userLocation] location] coordinate], 750, 750);
	}
}

- (void) goToDefaultLocationAndZoom {
	CLLocationCoordinate2D coordinate;
	
	coordinate.latitude = 59.913192;
	coordinate.longitude = 10.75813;
	
	[mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 400, 400) animated:YES];
}

- (IBAction)clubZoomButton:(id)sender {
	if (followingLocation) {
		[self locationButton:sender];
	}
	
	[self goToDefaultLocationAndZoom];
}

- (IBAction)typeSegmentSelected:(id)sender {
	UISegmentedControl* segCtl = sender;

	if ([segCtl selectedSegmentIndex] == 0) {
		[mapView setMapType:MKMapTypeStandard];
	} else if ([segCtl selectedSegmentIndex] == 1) {
		[mapView setMapType:MKMapTypeSatellite];
	} else if ([segCtl selectedSegmentIndex] == 2) {
		[mapView setMapType:MKMapTypeHybrid];
	}
		
}

@end
