//
//  MapViewController.swift
//  interview-app-swift
//
//  Created by Tony Nuzzi on 6/4/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CoffeeShopFinderServiceDelegate {

    weak var coffeeShopFinderService: CoffeeShopFinderService?
    
    // Making refreshButton strong reference since controller removes button and replaces
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    // Constant from pin
    let defaultPinID = "CustomPinAnnotationView"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set MapView Delegate
        self.mapView.delegate = self

        // Get coffee shop finder service instance and add delegate
        self.coffeeShopFinderService = (UIApplication.sharedApplication().delegate as! AppDelegate).coffeeShopFinderService
        self.coffeeShopFinderService?.addDelegate(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshTapped(sender: AnyObject) {
        self.coffeeShopFinderService?.findCoffeeshopsInMyArea()
        
        // Replace refresh button with activity indicator
        self.refreshButton.enabled = false
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        
        // Set the activity indicator size
        activityView.frame = CGRectMake(0, 0, 25, 25)
        activityView.sizeToFit()
        activityView.autoresizingMask = (UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin)
        
        // Add a new button bar item and set on nav bar
        let loadingView = UIBarButtonItem(customView: activityView)
        self.navigationItem.rightBarButtonItem = loadingView
        
        // Animate the spinner
        activityView.startAnimating()
    }

    // MARK: - CoffeeShopFinderServiceDelegate
    
    func coffeeShopsInMyArea(coffeeShops: [CoffeeshopModel], myLatitiude latitude: CLLocationDegrees, andLongitude longitude: CLLocationDegrees) {
        
        // Center map around current user location
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(latitude, longitude), 10000, 10000), animated: false)
        
        // Remove any pins on the th map before dropping new ones
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        // Iterate through the coffee shop models array and add them as annotations
        var index = 0
        for coffeeshop in coffeeShops {
            let annotation = CoffeeShopPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(coffeeshop.latitude!, coffeeshop.longitude!)
            annotation.title = coffeeshop.name!
            annotation.subtitle = "\(coffeeshop.rating!) stars (\(coffeeshop.reviewCount!) reviews)"
            annotation.index = index++
            
            self.mapView.addAnnotation(annotation)
        }
        
        // Reset right nav button to the refresh button
        self.navigationItem.rightBarButtonItem = self.refreshButton
        self.refreshButton.enabled = true
    }
    
    func noCoffeeshopsFound(atLatitude: CLLocationDegrees, andLongitude: CLLocationDegrees) {
        // Center map around current user location
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(atLatitude, andLongitude), 10000, 10000), animated: false)
        
        // Reset right nav button to the refresh button
        self.navigationItem.rightBarButtonItem = self.refreshButton
        self.refreshButton.enabled = true
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        // Make sure annotation class
        if(annotation.isKindOfClass(MKPointAnnotation)) {
            
            // Attempt to get Dequeued annotation
            var pinView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(self.defaultPinID) as? MKPinAnnotationView
            
            // If nil create a new annotation view
            if (pinView == nil) {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: self.defaultPinID)
                pinView!.animatesDrop = true
                pinView!.canShowCallout = true
                
                // Set disclosure button
                let rightButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
                pinView!.rightCalloutAccessoryView = rightButton
            } else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        self.performSegueWithIdentifier("details", sender: view.annotation)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
       // Get the index from the annotation and set it on the detail view controller
        let annotation = sender as! CoffeeShopPointAnnotation
        let model = self.coffeeShopFinderService?.coffeeShopsInMyArea[annotation.index!]
        
        // Set model on detail vc
        let detailVC = segue.destinationViewController as! CoffeeshopDetailViewController
        detailVC.model = model
    }
}
