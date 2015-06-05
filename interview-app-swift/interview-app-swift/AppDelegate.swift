//
//  AppDelegate.swift
//  interview-app-swift
//
//  Created by Tony Nuzzi on 5/17/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Coffee Shop Finder Service
    var coffeeShopFinderService: CoffeeShopFinderService?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initialize the Coffee Shop Service finder
        self.coffeeShopFinderService = CoffeeShopFinderService()
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Stop if app is pushed to the background
        self.coffeeShopFinderService!.stop()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Resume if app is forgrounded
        self.coffeeShopFinderService!.resume()
    }
}

