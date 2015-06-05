//
//  ListTableViewCell.swift
//  interview-app-swift
//
//  Created by Tony Nuzzi on 6/4/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var numOfReviews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Make the business circle completely round
        businessImage.businessImageCircle()
    }
}