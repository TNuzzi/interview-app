//
//  ListTableViewController.h
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/22/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoffeeShopFinderService.h"
#import "CoffeeshopModel.h"
#import "AppDelegate.h"

@interface ListTableViewController : UITableViewController <CoffeeShopFinderServiceDelegate>

@property (weak, nonatomic) CoffeeShopFinderService* coffeeShopFinderService;

// Making this strong because it will removed and readded
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

- (IBAction)refreshTapped:(id)sender;

@end
