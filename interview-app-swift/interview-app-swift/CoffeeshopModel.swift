//
//  CoffeeshopModel.swift
//  interview-app-swift
//
//  Created by Tony Nuzzi on 6/2/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

import Foundation
import CoreLocation

struct CoffeeshopModel {
    var name: String?
    var address: String?
    var imageURL: String?
    var ratingURL: String?
    var mobileURL: String?
    var phone: String?
    var rating: String?
    var reviewCount: String?
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
}