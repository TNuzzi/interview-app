//
//  ViewController.m
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/17/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.statusLabel = [[UILabel alloc] init];
//    self.statusLabel.text = @"Last Updated: 1/1/2015";
//    self.statusLabel.font = [UIFont systemFontOfSize:14];
//    [self.statusLabel setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0]];
//    [self.statusLabel sizeToFit];
//    self.status.customView = self.statusLabel;
//    
//    UIView *bottomBorder = [UIView new];
//    bottomBorder.backgroundColor = [UIColor lightGrayColor];
//    bottomBorder.frame = CGRectMake(0, self.topToolbar.frame.size.height - 1, self.topToolbar.frame.size.width, 0.5);
//    [self.topToolbar addSubview:bottomBorder];

//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [self.locationManager requestWhenInUseAuthorization];
//    }
//    [self.locationManager startUpdatingLocation];
    
//    [self.statusView layoutIfNeeded];
    
    // Do any additional setup after loading the view, typically from a nib.
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
