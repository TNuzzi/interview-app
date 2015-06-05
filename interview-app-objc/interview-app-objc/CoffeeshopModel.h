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

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *ratingURL;
@property (nonatomic, copy) NSString *mobileURL;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *rating;
@property (nonatomic, copy) NSString *reviewCount;

@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;

@end
