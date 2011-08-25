//
//  MapViewController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "MapViewController.h"

#import "ClubzoneMapAnnotation.h"
#import "JavaZonePrefs.h"

@implementation MapViewController

@synthesize mapView;
@synthesize toolbar;
@synthesize followingLocation;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.followingLocation = NO;
	
    [super viewDidLoad];

	NSArray *pins = [JavaZonePrefs clubZonePins];
	
	for (NSDictionary *pin in pins) {
		CLLocationCoordinate2D coordinate = {
			[[pin objectForKey:@"Latitude"] doubleValue],
			[[pin objectForKey:@"Longitude"] doubleValue]
		};
		
		NSString *title = [[[NSString alloc] initWithString:[pin objectForKey:@"Title"]] autorelease];
		NSString *subtitle = [[[NSString alloc] initWithString:[pin objectForKey:@"Subtitle"]] autorelease];

		NSString *pinIcon;
		
		if ([[pin allKeys] containsObject:@"Pin"]) {
			pinIcon = [[[NSString alloc] initWithString:[pin objectForKey:@"Pin"]] autorelease];
		} else {
			pinIcon = nil;
		}
		
		[self.mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:coordinate andTitle:title andSubtitle:subtitle andPinIcon:pinIcon] autorelease]];
	}
	
	self.mapView.showsUserLocation = YES;
	
	[self.mapView.userLocation addObserver:self  
								forKeyPath:@"location"  
								   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
								   context:NULL];
	
	[self goToDefaultLocationAndZoom];
}

- (void)viewWillAppear:(BOOL)animated {
	[FlurryAnalytics logEvent:@"Showing Map"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath  
                     ofObject:(id)object  
                       change:(NSDictionary *)change  
                      context:(void *)context {  
	
    if (self.followingLocation) {
		[self.mapView setCenterCoordinate:[[[self.mapView userLocation] location] coordinate] animated:YES];
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
	
	if ([annotation isKindOfClass:[ClubzoneMapAnnotation class]]) {
		ClubzoneMapAnnotation *czAnnotation = (ClubzoneMapAnnotation *)annotation;
		
		if (czAnnotation.pin != nil) {
			UIImageView *leftIconView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[czAnnotation pin]]] autorelease];
			pinView.leftCalloutAccessoryView = leftIconView;
		}
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
    
    self.mapView = nil;
    self.toolbar = nil;
}

- (void)dealloc {
	self.mapView.showsUserLocation = NO;
	[self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    
    [mapView release];
    [toolbar release];
    
    [super dealloc];
}

- (void) closeModalViewController:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)locationButton:(id)sender {
	self.followingLocation = !self.followingLocation;
	
	if (self.followingLocation == NO) {
		[self.toolbar setTintColor:[UIColor blackColor]];
	} else {
		[self.toolbar setTintColor:[UIColor blueColor]];
		self.mapView.region = MKCoordinateRegionMakeWithDistance([[[self.mapView userLocation] location] coordinate], 750, 750);
	}
}

- (void) goToDefaultLocationAndZoom {
	CLLocationCoordinate2D coordinate;
	
	coordinate.latitude = 59.913192;
	coordinate.longitude = 10.75813;
	
	[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 400, 400) animated:YES];
}

- (IBAction)clubZoomButton:(id)sender {
	if (self.followingLocation) {
		[self locationButton:sender];
	}
	
	[self goToDefaultLocationAndZoom];
}

- (IBAction)typeSegmentSelected:(id)sender {
	UISegmentedControl* segCtl = sender;
	
	if ([segCtl selectedSegmentIndex] == 0) {
		[self.mapView setMapType:MKMapTypeStandard];
	} else if ([segCtl selectedSegmentIndex] == 1) {
		[self.mapView setMapType:MKMapTypeSatellite];
	} else if ([segCtl selectedSegmentIndex] == 2) {
		[self.mapView setMapType:MKMapTypeHybrid];
	}
	
}

@end
