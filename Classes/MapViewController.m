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
	followingLocation = NO;
	
    [super viewDidLoad];

	[[locationToggle layer] setCornerRadius:8.0f];
	[[locationToggle layer] setMasksToBounds:YES];
	
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.912958,10.754421}
																	  andName:@"JavaZone"
															 andEntertainment:@"Oslo Spektrum"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.91291,10.761501}
																	  andName:@"Gloria Flames"
															 andEntertainment:@"Piano Bar"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.912149,10.765695}
																	  andName:@"Ivars Kro"
															 andEntertainment:@"Cover Band"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.913128,10.760233}
																	  andName:@"Dattera til Hagen"
															 andEntertainment:@"Stand-Up"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.913696,10.756906}
																	  andName:@"Cafe Con Bar"
															 andEntertainment:@"DJ"] autorelease]];

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
	followingLocation = !followingLocation;
	
	[locationToggle setSelected:followingLocation];
	
	if (followingLocation == NO) {
		[locationToggle setBackgroundColor:[UIColor clearColor]];
		[self goToDefaultLocationAndZoom];
	} else {
		[locationToggle setBackgroundColor:[UIColor blueColor]];
		mapView.region = MKCoordinateRegionMakeWithDistance([[[self.mapView userLocation] location] coordinate], 750, 750);
	}
}

- (void) goToDefaultLocationAndZoom {
	CLLocationCoordinate2D coordinate;
	
	coordinate.latitude = 59.912337;
	coordinate.longitude = 10.760036;
	
	[mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 750, 750) animated:YES];
}

@end
