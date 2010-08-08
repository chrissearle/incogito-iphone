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


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	showingLocation = NO;
	
    [super viewDidLoad];

	[self goToDefaultLocationAndZoom];

	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.912958,10.754421} andName:@"JavaZone - Oslo Spektrum"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.91291,10.761501} andName:@"Gloria Flames"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.912149,10.765695} andName:@"Ivars Kro"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.913128,10.760233} andName:@"Dattera til Hagen"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.913696,10.756906} andName:@"Cafe Con Bar"] autorelease]];

	mapView.showsUserLocation = showingLocation;
	
	[self.mapView.userLocation addObserver:self  
								forKeyPath:@"location"  
								   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
								   context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath  
                     ofObject:(id)object  
                       change:(NSDictionary *)change  
                      context:(void *)context {  
	
    if ([self.mapView showsUserLocation]) {  
		mapView.region = MKCoordinateRegionMakeWithDistance([[[self.mapView userLocation] location] coordinate], 750, 750);
    } else {
		[self goToDefaultLocationAndZoom];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation {
	if ([annotation class] == MKUserLocation.class) {
        return nil;
    }
	
	MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mv dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
	
	if(pinView == nil) {
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
		
		pinView.pinColor = MKPinAnnotationColorPurple;
		pinView.animatesDrop = YES;
		pinView.canShowCallout = YES;
	} else {
		pinView.annotation = annotation;
	}
	return pinView;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [super dealloc];
}

- (void) closeModalViewController:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)locationButton:(id)sender {
	showingLocation = !showingLocation;
	
	mapView.showsUserLocation = showingLocation;
	[locationToggle setSelected:showingLocation];
	
	if (showingLocation == NO) {
		[self goToDefaultLocationAndZoom];
	}
}

- (void) goToDefaultLocationAndZoom {
	CLLocationCoordinate2D coordinate;
	
	coordinate.latitude = 59.912337;
	coordinate.longitude = 10.760036;
	
	mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 750, 750);
}

@end
