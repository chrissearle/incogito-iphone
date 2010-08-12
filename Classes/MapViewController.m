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
@synthesize toolbar;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	followingLocation = NO;
	
    [super viewDidLoad];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"incogito" ofType:@"plist"];
	NSDictionary* plistDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
	
	NSArray *pins = [plistDict objectForKey:@"ClubZone"];
	
	for (NSDictionary *pin in pins) {
		CLLocationCoordinate2D coordinate = {
			[[pin objectForKey:@"Latitude"] doubleValue],
			[[pin objectForKey:@"Longitude"] doubleValue]
		};
		
		NSString *title = [[[NSString alloc] initWithString:[pin objectForKey:@"Title"]] autorelease];
		NSString *subtitle = [[[NSString alloc] initWithString:[pin objectForKey:@"Subtitle"]] autorelease];
		
		NSLog(@"Adding pin at %f, %f : %@ - %@", coordinate.latitude, coordinate.longitude, title, subtitle);
		
		[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:coordinate andTitle:title andSubtitle:subtitle] autorelease]];
	}
	
	[plistDict release];
	
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
	mapView.showsUserLocation = NO;
	[mapView.userLocation removeObserver:self forKeyPath:@"location"];
    [super dealloc];
}

- (void) closeModalViewController:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)locationButton:(id)sender {
	followingLocation = !followingLocation;
	
	if (followingLocation == NO) {
		[toolbar setTintColor:[UIColor blackColor]];
	} else {
		[toolbar setTintColor:[UIColor blueColor]];
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
