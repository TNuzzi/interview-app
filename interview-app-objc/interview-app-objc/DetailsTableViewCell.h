//
//  DetailsTableViewCell.h
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/29/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
