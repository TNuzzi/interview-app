//
//  YelpAPIServiceDelegate.swift
//  interview-app-swift
//
//  Created by Tony Nuzzi on 6/2/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import SwiftyJSON
import OAuthConsumer

protocol YelpAPIServiceDelegate {
    func loadResultWithDataArray(resultArray: [CoffeeshopModel])
}

class YelpAPIService: NSObject, NSURLConnectionDataDelegate {
    // Constants for Yelp API
    let YelpSearchUrl = "http://api.yelp.com/v2/search"
    let SearchResultLimit = "20"
    
    var urlRespondData: NSMutableData?
    var delegate: YelpAPIServiceDelegate?
    
    // Used to find all the coffee shops in the user geolocated area
    func findNearByCoffeshopsByLocation(location: String, aLatitude latitude: CLLocationDegrees, andLongitude longitude: CLLocationDegrees) {
        
        // Setup Yelp API URL
        let urlString = String("\(self.YelpSearchUrl)?term=coffee&location=\(location)&cll=\(latitude),\(longitude)&limit=\(self.SearchResultLimit)&sort=1").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let url = NSURL(string: urlString)
        
        // Setup OAuth consumer class
        let consumer = OAConsumer(key: OAuthAPIConstants.OAuthConsumerKey,
                                  secret: OAuthAPIConstants.OAuthConsumerSecret)
        let token = OAToken(key: OAuthAPIConstants.OAuthToken,
                            secret: OAuthAPIConstants.OAuthTokenSecret)
        let provider = OAHMAC_SHA1SignatureProvider();
        let request = OAMutableURLRequest(URL: url, consumer: consumer, token: token, realm: nil, signatureProvider: provider)
        
        request.prepare()
        
        // Prepare url connection to reveive data
        if let conn = NSURLConnection(request: request, delegate: self) {
            self.urlRespondData = NSMutableData()
        }
    }
    
    // Mark: NSURLConnectionDataDelegate
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        self.urlRespondData!.length = 0;
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.urlRespondData!.appendData(data);
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        var userInfo: NSDictionary = error.userInfo!;
        var errorString: String = userInfo.objectForKey(NSUnderlyingErrorKey)!.localizedDescription
        
        // Log error to console
        println("\(errorString)")
        
        // Initialize alert controller
        var alertController = UIAlertController(title: "Error", message: "Failed to connect to Yelp server.", preferredStyle: .Alert)
        
        // Ok Action button and add to controller
        var okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        // Show Alert controller
        UIApplication.sharedApplication().delegate!.window!!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        // Convert NSMutableData to NSData and pass into SwiftyJSON
        let resultJSON = JSON(data: NSData(data: self.urlRespondData!))
        
        if resultJSON != nil {
            // Get all the business from yelp results
            let businesses = resultJSON["businesses"]
            
            var coffeeshops: [CoffeeshopModel] = []
            
            // Check for business and iterate through them
            if businesses.count > 0 {
                
                // Iterate through the JSON results and create CoffeeshopModel from each business
                /* Consdensed version
                {
                    "rating": 5.0,
                    "mobile_url": "http://m.yelp.com/biz/the-flying-falafel-san-francisco-3",
                    "rating_img_url": "http://s3-media1.fl.yelpcdn.com/assets/2/www/img/f1def11e4e79/ico/stars/v1/stars_5.png",
                    "review_count": 183,
                    "name": "The Flying Falafel",
                    "image_url": "http://s3-media1.fl.yelpcdn.com/bphoto/0f3f_XWaIfnx_0Lqq_vEeA/ms.jpg",
                    "display_phone": "+1-415-964-1003",
                    "location": {
                        "display_address": [
                            "1051 Market St",
                            "SoMa",
                            "San Francisco, CA 94103"
                        ]
                    }
                }
                */
                for (index: String, coffeeshop: JSON) in businesses {
                    var model = CoffeeshopModel()
                    model.name = coffeeshop["name"].stringValue
                    model.imageURL = coffeeshop["image_url"].stringValue
                    model.ratingURL = coffeeshop["rating_img_url"].stringValue
                    model.mobileURL = coffeeshop["mobile_url"].stringValue
                    model.rating = coffeeshop["rating"].stringValue
                    model.reviewCount = coffeeshop["review_count"].stringValue
                    model.phone = coffeeshop["display_phone"].stringValue
                    model.address = join(", ", coffeeshop["location"]["display_address"].arrayObject as! [String])
                    
                    model.latitude = coffeeshop["location"]["coordinate"]["latitude"].doubleValue
                    model.longitude = coffeeshop["location"]["coordinate"]["longitude"].doubleValue
                    
                    coffeeshops.append(model)
                }
            }
            
            // Notify delegate
            self.delegate?.loadResultWithDataArray(coffeeshops);
        }
    }
}