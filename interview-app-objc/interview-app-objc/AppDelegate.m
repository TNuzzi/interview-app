//
//  AppDelegate.m
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/17/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize Coffee shop finder service
    [self setCoffeeShopFinderService:[[CoffeeShopFinderService alloc] init]];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Stop Coffee shop finder service when the app enters the background
    [self.coffeeShopFinderService stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Resume Coffee shop finder service when the app become active again
    [self.coffeeShopFinderService resume];
}

@end
