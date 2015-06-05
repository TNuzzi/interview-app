//
//  ListTableViewController.swift
//  interview-app-swift
//
//  Created by Tony Nuzzi on 6/4/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

import UIKit
import CoreLocation
import SDWebImage

class ListTableViewController: UITableViewController, CoffeeShopFinderServiceDelegate {

    weak var coffeeShopFinderService: CoffeeShopFinderService?
    
    // Making strong reference since controller removes button and replaces
    @IBOutlet var refreshButton: UIBarButtonItem!
    
    let CellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get coffee shop finder service instance and add delegate
        self.coffeeShopFinderService = (UIApplication.sharedApplication().delegate as! AppDelegate).coffeeShopFinderService
        self.coffeeShopFinderService?.addDelegate(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func refreshTapped(sender: AnyObject) {
        // Call coffee shop finder service to start location look up
        self.coffeeShopFinderService?.findCoffeeshopsInMyArea()
        
        // Scroll to the top if there are rows in the table
        if (self.numberOfSectionsInTableView(self.tableView) > 0) {
            let top = NSIndexPath(forRow: NSNotFound, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(top, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
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
        
        // Reload tableView with new data
        self.tableView.reloadData()
        
        // Reset right nav button to the refresh button
        self.navigationItem.rightBarButtonItem = self.refreshButton
        self.refreshButton.enabled = true
        
    }
    
    func noCoffeeshopsFound(atLatitude: CLLocationDegrees, andLongitude: CLLocationDegrees) {
        // Clear table to indicate no coffee shops found
        self.tableView.reloadData()
        
        // Reset right nav button to the refresh button
        self.navigationItem.rightBarButtonItem = self.refreshButton
        self.refreshButton.enabled = true
    }
    
    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coffeeShopFinderService!.coffeeShopsInMyArea.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(self.CellId, forIndexPath: indexPath) as! ListTableViewCell
        
        // Get the appropriate model from the coffeeshopsInMyArea array
        let model = self.coffeeShopFinderService?.coffeeShopsInMyArea[indexPath.row]
        
        // Setting the name label
        cell.name.text = model!.name!
        
        // Setting the review count label
        cell.numOfReviews.text = " - \(model!.reviewCount!) reviews"
        
        // Setting main business image, using yelp image as the placeholder
        cell.businessImage.sd_setImageWithURL(NSURL(string: model!.imageURL!), placeholderImage: UIImage(named: "yelp"))
        
        // Setting ratings image
        cell.ratingImage.sd_setImageWithURL(NSURL(string: model!.ratingURL!))
        
        return cell
    }

    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("details", sender: indexPath)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get index and look up model
        let indexPath = sender as! NSIndexPath
        let model = self.coffeeShopFinderService?.coffeeShopsInMyArea[indexPath.row]
        
        // Set model on detail vc
        let detailVC = segue.destinationViewController as! CoffeeshopDetailViewController
        detailVC.model = model
    }

}
