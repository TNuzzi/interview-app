//
//  MapViewController.m
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/22/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setDelegate:self];
}

- (void) viewDidAppear:(BOOL)animated {
    
    // Get the coffeeshop finder service instance and add self as a delegate
    AppDelegate *appDeleate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setCoffeeShopFinderService:[appDeleate coffeeShopFinderService]];
    [self.coffeeShopFinderService addDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshTapped:(id)sender {
    NSLog(@"Clicked");
    // Call coffee shop finder service to start location look up
    [self.coffeeShopFinderService findCoffeeshopsInMyArea];
    
    
    // Replace refresh button with the activity indicator
    [self.refreshButton setEnabled:NO];
    
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setFrame:CGRectMake(0, 0, 25, 25)];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [self.navigationItem setRightBarButtonItem:loadingView];
    [activityView startAnimating];
}

#pragma mark - CoffeeShopFinderServiceDelegate

- (void)coffeeshopsInMyArea:(NSArray *)resultArray myLatitude:(CLLocationDegrees)latitude
              andLongitude:(CLLocationDegrees)longitude {
    
    // Center map around current latitude/longitude
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(latitude, longitude), 10000, 10000) animated:YES];
    
    // Remove any pins on the map before dropping new ones
    [self.mapView removeAnnotations:self.mapView.annotations];

    for (CoffeeshopModel* coffeeshop in resultArray) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate: CLLocationCoordinate2DMake(coffeeshop.latitude, coffeeshop.longitude)];
        [annotation setTitle:coffeeshop.name];
        [annotation setSubtitle:[NSString stringWithFormat:@"%@ stars (%@ reviews)",
                                 coffeeshop.rating,
                                 coffeeshop.reviewCount]];

        [self.mapView addAnnotation:annotation];
    }
    
    // Reset right nav button to the refresh button
    [self.navigationItem setRightBarButtonItem:self.refreshButton];
    [self.refreshButton setEnabled:YES];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // Create a static string of pin identifier
    static NSString* defaultPinID = @"CustomPinAnnotationView";
    
    // Handle annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
            [pinView setCanShowCallout:YES];
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [pinView setRightCalloutAccessoryView:rightButton];
        } else {
            [pinView setAnnotation:annotation];
        }
        
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"tapped");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
