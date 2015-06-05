//
//  UIImageExtension.swift
//  interview-app-swift
//
//  Created by Tony Nuzzi on 6/4/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

import UIKit

extension UIImageView {
    // Method that make the view as a circle
    func businessImageCircle() {
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
    }
}
