//
//  CoffeeshopDetailsViewController.m
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/28/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import "CoffeeshopDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CoffeeshopDetailsViewController

-(void) viewDidLoad {
    // Setup MapView
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(self.model.latitude, self.model.longitude), 1000, 1000) animated:NO];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:CLLocationCoordinate2DMake(self.model.latitude, self.model.longitude)];
    [self.mapView addAnnotation:annotation];
    
    // Set business name
    [self.name setText:[self.model name]];

    // Make image view rounded corners
    [self.businessImage.layer setCornerRadius:10];
    [self.businessImage.layer setMasksToBounds:YES];
    
    // Setting main business image, using yelp image as the placeholder
    [self.businessImage sd_setImageWithURL:[NSURL URLWithString: self.model.imageURL]
                  placeholderImage:[UIImage imageNamed:@"yelp"]];

    // Setting ratings image
    [self.ratingsImage sd_setImageWithURL:[NSURL URLWithString:self.model.ratingURL]];
    
    [self.reviewCount setText:[NSString stringWithFormat:@"%@ reviews", self.model.reviewCount]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] != 2) {
        return 44;
    }
    else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellId = @"detailsCell";
    
    // Since the table cell is coming from UITableViewController in the Main.storyboard a new instance is created
    // Don't need to check for nil
    DetailsTableViewCell *cell = (DetailsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    
    if(indexPath.row == 0) {
        [cell.leftImage setImage:[UIImage imageNamed:@"phone"]];
        [cell.content setText: self.model.phone];
    }
    else if(indexPath.row == 1) {
        [cell.leftImage setImage:[UIImage imageNamed:@"browser"]];
        [cell.content setText: @"Mobile Website"];
    } else {
        [cell.leftImage setImage:[UIImage imageNamed:@"pin"]];
        [cell.content setText: self.model.address];
        [cell.content sizeToFit];
        
        // Customize this cell
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // Remove the bottom seperator line
        [cell setSeparatorInset:UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel://%@", self.model.phone]]];
    }
    else if(indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.model.mobileURL]];
    }
}
@end
