//
//  CoffeeshopDetailsViewController.h
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/28/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CoffeeshopModel.h"
#import "DetailsTableViewCell.h"

@interface CoffeeshopDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) CoffeeshopModel* model;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *businessImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingsImage;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;
@property (weak, nonatomic) IBOutlet UILabel *yelpFooter;

@end
