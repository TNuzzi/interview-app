//
//  CoffeeShopFinderService.swift
//  interview-app-swift
//
//  Created by Tony Nuzzi on 6/2/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import AddressBook

protocol CoffeeShopFinderServiceDelegate {
    func coffeeShopsInMyArea(coffeeShops: [CoffeeshopModel], myLatitiude latitude: CLLocationDegrees,
        andLongitude longitude: CLLocationDegrees)
    func noCoffeeshopsFound(atLatitude: CLLocationDegrees, andLongitude: CLLocationDegrees)
}

class CoffeeShopFinderService: NSObject, CLLocationManagerDelegate, YelpAPIServiceDelegate {
    // Array to hold the CoffeeshopModels
    var coffeeShopsInMyArea: [CoffeeshopModel] = []
    
    // LocationManager and Geocoder for getting location and reverse geolocation lookup
    var locationManager: CLLocationManager?
    var geocoder: CLGeocoder?
    
    // Help service helper
    var yelpAPIService: YelpAPIService?
    
    // User's current location
    var myLatitude: CLLocationDegrees?
    var myLongitude: CLLocationDegrees?
    
    // Array of registered delegates
    private var _delegates: [CoffeeShopFinderServiceDelegate] = []
    
    override init() {
        super.init()
        
        // Initialize Yelp service class and assign delegate
        self.yelpAPIService = YelpAPIService()
        self.yelpAPIService?.delegate = self;
        
        // Initalize Geocoder
        self.geocoder = CLGeocoder()
        
        // Initialize LocationManager and assign delegate
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        
        // Measure geolocation accuracy to the ten meters (wanting quickness rather than accuracy)
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // Check with location manager to see if user has authorized app to get location information
        // If not show alert
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                self.locationManager!.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == .Denied ||
                      CLLocationManager.authorizationStatus() == .Restricted ||
                      CLLocationManager.authorizationStatus() == .AuthorizedAlways {
                self.showSettingAlertDialog()
            }
        }
    }
    
    func findCoffeeshopsInMyArea() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            self.locationManager?.startUpdatingLocation()
        } else if CLLocationManager.authorizationStatus() == .Denied ||
                  CLLocationManager.authorizationStatus() == .Restricted ||
                  CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            self.showSettingAlertDialog()
        }
    }
    
    // Used in app delegate when app is backgrounded
    func stop() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    // Used when app is placed in the foreground
    func resume() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func addDelegate(delegate: CoffeeShopFinderServiceDelegate) {
        self._delegates.append(delegate)
    }
    
    // Helper method to show alert if user has not authorized app
    private func showSettingAlertDialog() {
        // Initialize alert controller
        var alertController = UIAlertController(title: "Background Location Access Disabled", message: "In order to find coffee shops around you, please open this app's settings and set location access to 'While Using the App'.", preferredStyle: .Alert)
        
        // Cancel Action button and add to controller
        var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Open Action button and add to controller
        var openAction = UIAlertAction(title: "Open Settings", style: .Default, handler: {
            (action: UIAlertAction!) in
            if let settingUrl = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(settingUrl)
            }
        })
        alertController.addAction(openAction)
        
        // Show Alert controller
        // NOTE: Since this code is not run in UIViewController use the root view controller to present the alert
        UIApplication.sharedApplication().delegate!.window!!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Mark: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // Fail fast if not location are returned
        if locations.count == 0 {
            self.notifyDelegatesNoCoffeeshopsFound()
            return
        }
        
        // Location are placed in array chronologically, so last should be the latest
        var location = locations.last as! CLLocation
        
        // Setting user's location
        self.myLatitude = location.coordinate.latitude
        self.myLongitude = location.coordinate.longitude
        
        // Doing a reverse lookup to get address information
        self.geocoder!.reverseGeocodeLocation(location, completionHandler: {
            (placemarks: [AnyObject]!, error: NSError!) in
            
            // Fail fast if an error occured
            // To the user it will look like no coffeeshops are available
            if(error != nil) {
                self.notifyDelegatesNoCoffeeshopsFound()
                return
            }
            
            // If address can't not be determine notify user no coffee shops are available
            if placemarks.count == 0 {
                self.notifyDelegatesNoCoffeeshopsFound()
                return
            }
            
            // Cast array to array of CLPlacemark
            let placemarkArray = placemarks as! [CLPlacemark]
            
            // Get the address of the first location using the address dictionary
            let addressDict = placemarkArray[0].addressDictionary
            
            
            // Retrieve address information from address dictionary and concat together
            var searchLocation = "\(addressDict[kABPersonAddressStreetKey]) \(addressDict[kABPersonAddressCityKey]) \(addressDict[kABPersonAddressZIPKey])"
            
            // Call yelp service to lookup coffees shop at user's current location
            self.yelpAPIService?.findNearByCoffeshopsByLocation(searchLocation, aLatitude: self.myLatitude!, andLongitude: self.myLongitude!)
        })
        
        // Only get the first location then stop listening
        self.locationManager?.stopUpdatingLocation()
    }
    
    // Mark: - YelpAPIServiceDelegate
    func loadResultWithDataArray(resultArray: [CoffeeshopModel]) {
        // If no coffeeshops are found in user's location let them know
        if resultArray.count == 0 {
            self.coffeeShopsInMyArea = [];
            self.notifyDelegatesNoCoffeeshopsFound()
            
            return
        }
        
        // Array of coffee shop models
        self.coffeeShopsInMyArea = resultArray
        
        // Call all registered delegates
        for delegate: CoffeeShopFinderServiceDelegate in self._delegates {
            delegate.coffeeShopsInMyArea(self.coffeeShopsInMyArea, myLatitiude: self.myLatitude!, andLongitude: self.myLongitude!)
        }
    }
    
    // Mark: - Private
    private func notifyDelegatesNoCoffeeshopsFound() {
        
        // Make sure cached version is set to empty
        self.coffeeShopsInMyArea =  [];
        
        // Initialize alert controller
        var alertController = UIAlertController(title: "Sorry", message: "No coffee shops were found in your area.", preferredStyle: .Alert)
        
        // Ok Action button and add to controller
        var okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        // Show Alert controller
        UIApplication.sharedApplication().delegate!.window!!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
        
        // Call all registered delegates
        for delegate: CoffeeShopFinderServiceDelegate in self._delegates {
            delegate.noCoffeeshopsFound(self.myLatitude!, andLongitude: self.myLongitude!)
        }
    }
}