//
//  CoffeeshopDetailViewController.swift
//  interview-app-swift
//
//  Created by Tony Nuzzi on 6/4/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

import UIKit
import MapKit

class CoffeeshopDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Set model as strong reference
    var model: CoffeeshopModel?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var yelpFooter: UILabel!
    
    let CellId = "detailsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Center map background
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(self.model!.latitude!, self.model!.longitude!), 1000, 1000), animated: false)
        
        // Add annotation to indicate business location
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(self.model!.latitude!, self.model!.longitude!)
        self.mapView.addAnnotation(annotation)
        
        // Set business name
        self.name.text = self.model!.name!
        
        // Set styling on business image
        self.businessImage.layer.cornerRadius = 10
        self.businessImage.layer.masksToBounds = true
        
        // Setting main business image, using yelp image as the placeholder
        self.businessImage.sd_setImageWithURL(NSURL(string: model!.imageURL!), placeholderImage: UIImage(named: "yelp"))
        
        // Setting ratings image
        self.ratingImage.sd_setImageWithURL(NSURL(string: model!.ratingURL!))
        
        // Set review count
        self.reviewCount.text = "\(self.model!.reviewCount!) reviews"
    }
    
    // MARK: - Table view data source
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Set row height based on row index
        if (indexPath.row != 2)  {
            return 44
        } else {
            return 60
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.CellId, forIndexPath: indexPath) as! DetailsTableViewCell
        
        // Set rows based on id, hardcoding because table should be laid out the same for every business
        if (indexPath.row == 0) {
            cell.leftImage.image = UIImage(named: "phone")
            cell.content.text = self.model?.phone!
        } else if (indexPath.row == 1) {
            cell.leftImage.image = UIImage(named: "browser")
            cell.content.text = "Mobile Website"
        } else {
            cell.leftImage.image = UIImage(named: "pin")
            cell.content.text = self.model?.address!
            cell.sizeToFit()
            
            // Make last row not clickable
            cell.accessoryType = .None
            cell.selectionStyle = .None
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Make first two rows actionable
        if (indexPath.row == 0) {
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(self.model!.phone!)")!)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: self.model!.mobileURL!)!)
        }
    }
}
