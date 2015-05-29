//
//  CoffeeShopFinderService.h
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/28/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "YelpAPIService.h"
#import "CoffeeshopModel.h"

@protocol CoffeeShopFinderServiceDelegate <NSObject>
-(void)coffeeshopsInMyArea:(NSArray *)resultArray myLatitude:(CLLocationDegrees)latitude
              andLongitude:(CLLocationDegrees)longitude;
@end

@interface CoffeeShopFinderService : NSObject <CLLocationManagerDelegate, YelpAPIServiceDelegate>

@property (nonatomic, strong) NSArray* coffeeshopsInMyArea;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLGeocoder* geocoder;
@property (nonatomic, strong) YelpAPIService* yelpService;

@property CLLocationDegrees myLatitude;
@property CLLocationDegrees myLongitude;

@property (nonatomic, strong) NSHashTable* _delegates;

- (void) findCoffeeshopsInMyArea;

// Used to control the service when the app is backgrounded
- (void) stop;
- (void) resume;

- (void) addDelegate: (id<CoffeeShopFinderServiceDelegate>) delegate;
- (void) removeDelegate: (id<CoffeeShopFinderServiceDelegate>) delegate;

@end
