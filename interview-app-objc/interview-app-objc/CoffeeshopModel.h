//
//  CoffeeshopModel.h
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/25/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CoffeeshopModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *ratingURL;
@property (nonatomic, strong) NSString *mobileURL;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *reviewCount;

@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;

@end
