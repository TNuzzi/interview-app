//
//  MapViewController.h
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/22/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate>

@property CLLocationManager* locationManager;
@property CLGeocoder* geocoder;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)refreshTapped:(id)sender;

@end
