//
//  CoffeeShopFinderService.m
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/28/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import "CoffeeShopFinderService.h"

@implementation CoffeeShopFinderService

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // Create an empty array so consuming classes don't have to nil check
        [self setCoffeeshopsInMyArea:@[]];
        
        // Create a weak reference to the delegates added, as to not create a memory leak
        [self set_delegates:[NSHashTable weakObjectsHashTable]];
        
        // Initialize Yelp API service
        [self setYelpService:[[YelpAPIService alloc] init]];
        [self.yelpService setDelegate:self];
        
        // Initialize geocoder for reverse lookup
        [self setGeocoder:[[CLGeocoder alloc] init]];
        
        // Start initialization of CoreLocation Manager
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [self.locationManager setDelegate:self];
        
        // Set desired accuracy to "nearest ten meters".  Does not need to best accuracy
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        
        // Check to make sure location services are enabled on user's device
        if([CLLocationManager locationServicesEnabled]) {
            
            // If authorization status is not determined ask user permission
            if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                [self.locationManager requestWhenInUseAuthorization];
                
                // If user denied/rejected or is the wrong authorization; display alert with button to settings URL
            } else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
                      [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
                      [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
                
                [self showSettingAlertDialog];
            }
        }
    }
    return self;
}

-(void) findCoffeeshopsInMyArea {
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    } else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
              [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
              [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        [self showSettingAlertDialog];
    }
}

- (void) stop {
    [self.locationManager stopUpdatingLocation];
}

- (void) resume {
    [self.locationManager startUpdatingLocation];
}


- (void) addDelegate: (id<CoffeeShopFinderServiceDelegate>) delegate
{
    [self._delegates addObject: delegate];
}

// Calling this method is optional.
// The hash table will automatically remove the delegate when it gets released
- (void) removeDelegate: (id<CoffeeShopFinderServiceDelegate>) delegate
{
    [self._delegates removeObject: delegate];
}

#pragma mark - Private

- (void) showSettingAlertDialog {
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
    // NOTE: Since this code is not run in UIViewController use the root view controller to present the alert
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - CLLocationManagerDelegate

// Using deletage to start listening to updates for the location
- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
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
    
    [self setMyLatitude: location.coordinate.latitude];
    [self setMyLongitude: location.coordinate.longitude];
    
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

- (void)loadResultWithDataArray:(NSArray *)resultArray {
    
    // Cache results
    self.coffeeshopsInMyArea = [NSArray arrayWithArray:resultArray];
    
    // Call all registered delegates
    for(id<CoffeeShopFinderServiceDelegate> delegate in self._delegates){
        [delegate coffeeshopsInMyArea:self.coffeeshopsInMyArea myLatitude:self.myLatitude andLongitude:self.myLongitude];
    }
}
@end
