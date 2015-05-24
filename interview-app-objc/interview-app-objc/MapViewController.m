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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    if([CLLocationManager locationServicesEnabled]) {
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        } else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
                  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
                  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
            
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Background Location Access Disabled" message:@"In order to find coffee shops around you, please open this app's settings and set location access to 'Always'." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            
            UIAlertAction* openAction = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                NSURL* settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if (settingUrl != nil) {
                    [[UIApplication sharedApplication] openURL:settingUrl];
                }
            }];
            [alertController addAction:openAction];
            
            [self.parentViewController presentViewController:alertController animated:YES completion:nil];
        } else  {
            [self.locationManager startUpdatingLocation];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"status: %i", status);
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
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
