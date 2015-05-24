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
    
    self.mapView.showsUserLocation = YES;
    
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
    NSLog(@"number in array: %lu", (unsigned long)locations.count);
    
    CLLocation* location = locations[0];
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000) animated:YES];
    
    NSLog(@"latitude: %f, Longitude: %f", location.coordinate.latitude, location.coordinate.longitude);
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error){
        if ([placemarks count] > 0)
        {
            NSLog(@"postalCode %@", [[placemarks objectAtIndex:0] postalCode]);
        }
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate: CLLocationCoordinate2DMake(37.7762794, -122.4181595)];
        [annotation setTitle:@"Ma'velous"]; //You can set the subtitle too
        [self.mapView addAnnotation:annotation];
    }];
    
    // Just get the first location update then stop
    [self.locationManager stopUpdatingLocation];
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
