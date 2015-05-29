//
//  AppDelegate.h
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/17/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoffeeShopFinderService.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CoffeeShopFinderService* coffeeShopFinderService;

@end

