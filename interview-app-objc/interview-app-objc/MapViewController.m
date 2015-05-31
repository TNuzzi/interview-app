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
    // Call coffee shop finder service to start location look up
    [self.coffeeShopFinderService findCoffeeshopsInMyArea];
    
    
    // Replace refresh button with the activity indicator
    [self.refreshButton setEnabled:NO];
    
    // Create an activity indicator and replace the refresh button
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // Set the activity indicator size
    [activityView setFrame:CGRectMake(0, 0, 25, 25)];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    
    // Add to new Button bar item and set on nav bar
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [self.navigationItem setRightBarButtonItem:loadingView];
    
    // Start spinning
    [activityView startAnimating];
}

#pragma mark - CoffeeShopFinderServiceDelegate

- (void)coffeeshopsInMyArea:(NSArray *)resultArray myLatitude:(CLLocationDegrees)latitude
              andLongitude:(CLLocationDegrees)longitude {
    
    // Center map around current latitude/longitude
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(latitude, longitude), 10000, 10000) animated:NO];
    
    // Remove any pins on the map before dropping new ones
    [self.mapView removeAnnotations:self.mapView.annotations];

    NSUInteger index = 0;
    for (CoffeeshopModel* coffeeshop in resultArray) {
        CoffeeShopPointAnnotation *annotation = [[CoffeeShopPointAnnotation alloc] init];
        [annotation setCoordinate: CLLocationCoordinate2DMake(coffeeshop.latitude, coffeeshop.longitude)];
        [annotation setTitle:coffeeshop.name];
        [annotation setSubtitle:[NSString stringWithFormat:@"%@ stars (%@ reviews)",
                                 coffeeshop.rating,
                                 coffeeshop.reviewCount]];
        [annotation setIndex:index++];
        
        [self.mapView addAnnotation:annotation];
    }
    
    // Reset right nav button to the refresh button
    [self.navigationItem setRightBarButtonItem:self.refreshButton];
    [self.refreshButton setEnabled:YES];
}

-(void) noCoffeeshopsFoundAtLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude {
    // Center map around current latitude/longitude
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(latitude, longitude), 10000, 10000) animated:NO];
    
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
            [pinView setAnimatesDrop:YES];
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
    [self performSegueWithIdentifier:@"details" sender:view.annotation];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the index from the annotation and set it on the detail view controller
    CoffeeShopPointAnnotation *annotation = (CoffeeShopPointAnnotation *) sender;
    CoffeeshopModel *model = [[self.coffeeShopFinderService coffeeshopsInMyArea] objectAtIndex:annotation.index];
    
    CoffeeshopDetailsViewController *detailVC = [segue destinationViewController];
    [detailVC setModel:model];
}

@end
