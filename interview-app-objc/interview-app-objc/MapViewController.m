//
//  MapViewController.m
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/22/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import "MapViewController.h"
#import "CoffeeshopModel.h"
#import <AddressBook/AddressBook.h>

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    // Initialize Yelp API service
    self.yelpService = [[YelpAPIService alloc] init];
    self.yelpService.delegate = self;
    
    // Initialize geocoder for reverse lookup
    self.geocoder = [[CLGeocoder alloc] init];
    
    // Start initialization of CoreLocation Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Set desired accuracy to "nearest ten meters".  Does not need to best accuracy
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // Check to make sure location services are enabled on user's device
    if([CLLocationManager locationServicesEnabled]) {
        
        // If authorization status is not determined ask user permission
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        
        // If user denied/rejected or is the wrong authorization; display alert with button to settings URL
        } else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
                  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
                  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
            
            // Initialize alert controller
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Background Location Access Disabled" message:@"In order to find coffee shops around you, please open this app's settings and set location access to 'Always'." preferredStyle:UIAlertControllerStyleAlert];
            
            // Cancel Action button
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            
            // Open Settings action button
            UIAlertAction* openAction = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                NSURL* settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if (settingUrl != nil) {
                    [[UIApplication sharedApplication] openURL:settingUrl];
                }
            }];
            [alertController addAction:openAction];
            
            // Show Alert controller
            [self.parentViewController presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshTapped:(id)sender {
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate

// Using deletage to start listening to updates for the location
- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"status: %i", status);
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // Fail fast if there are no locations
    if([locations count] == 0) {
        return;
    }
    
    // Get the first location (User's current location)
    CLLocation* location = [locations objectAtIndex:0];
    
    // Move map to user's current location and zoom in
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000) animated:YES];
    
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error){
        // Fail fast if we have errors or can't reverse lookup location
        if(error != nil) {
            NSDictionary *userInfo = [error userInfo];
            NSString *errorString = [[userInfo objectForKey:NSUnderlyingErrorKey] localizedDescription];
            NSLog(@"%@", errorString);
            
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Failed to lookup location address"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }
        
        if([placemarks count] == 0) {
            return;
        }
        
        NSDictionary* dict = [[placemarks objectAtIndex:0] addressDictionary];
        
        NSString* searchLocation = [NSString stringWithFormat:@"%@ %@ %@",
              [dict objectForKey:(NSString *) kABPersonAddressStreetKey],
              [dict objectForKey:(NSString *) kABPersonAddressCityKey],
              [dict objectForKey:(NSString *) kABPersonAddressZIPKey]];
        
        [self.yelpService findNearByCoffeshopsByLocation:searchLocation aLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    }];
    
    // Just get the first location update then stop
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - YelpAPIServiceDelegate

-(void)loadResultWithDataArray:(NSArray *)resultArray {
    NSLog(@"resultArray count: %lu", (unsigned long)resultArray.count);
    
    for (CoffeeshopModel* coffeeshop in resultArray) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate: CLLocationCoordinate2DMake(coffeeshop.latitude, coffeeshop.longitude)];
        [annotation setTitle:coffeeshop.name];
        [annotation setSubtitle:[NSString stringWithFormat:@"%@ stars (%@ reviews)",
                                         coffeeshop.rating,
                                         coffeeshop.reviewCount]];
        NSLog(@"coffeeshop.name: %@", coffeeshop.name);
        [self.mapView addAnnotation:annotation];
    }
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
            pinView.canShowCallout = YES;
            pinView.animatesDrop = YES;
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
            
        } else {
            pinView.annotation = annotation;
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
