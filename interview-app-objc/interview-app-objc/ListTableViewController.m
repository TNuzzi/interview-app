//
//  ListTableViewController.m
//  interview-app-objc
//
//  Created by Tony Nuzzi on 5/22/15.
//  Copyright (c) 2015 Tony Nuzzi. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "ListTableViewController.h"
#import "ListTableViewCell.h"


@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Get the coffeeshop finder service instance and add self as a delegate
    AppDelegate *appDeleate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setCoffeeShopFinderService:[appDeleate coffeeShopFinderService]];
    [self.coffeeShopFinderService addDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshTapped:(id)sender {
    // Call coffee shop finder service to start location look up
    [self.coffeeShopFinderService findCoffeeshopsInMyArea];
    
    // Scroll to the top if there are
    if ([self numberOfSectionsInTableView:self.tableView] > 0)
    {
        NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
        [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    
    // Replace refresh button with the activity indicator
    [self.refreshButton setEnabled:NO];
    
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setFrame:CGRectMake(0, 0, 25, 25)];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [self.navigationItem setRightBarButtonItem:loadingView];
    [activityView startAnimating];
}

#pragma mark - CoffeeShopFinderServiceDelegate

- (void)coffeeshopsInMyArea:(NSArray *)resultArray myLatitude:(CLLocationDegrees)latitude
               andLongitude:(CLLocationDegrees)longitude {
    
    // Reload tableView
    [self.tableView reloadData];
    
    // Reset right nav button to the refresh button
    [self.navigationItem setRightBarButtonItem:self.refreshButton];
    [self.refreshButton setEnabled:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.coffeeShopFinderService coffeeshopsInMyArea].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellId = @"cell";
    
    // Since the table cell is coming from UITableViewController in the Main.storyboard a new instance is created
    // Don't need to check for nil
    ListTableViewCell *cell = (ListTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    
    // Get the appropriate model from the coffeeshopsInMyArea array
    CoffeeshopModel *model = [[self.coffeeShopFinderService coffeeshopsInMyArea] objectAtIndex:indexPath.row];
    
    // Setting the name label
    [cell.name setText: model.name];
    
    // Setting the review count label
    [cell.numOfReviews setText:[NSString stringWithFormat:@" - (%@ reviews)", model.reviewCount]];

    // Setting main business image, using yelp image as the placeholder
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.imageURL]
                  placeholderImage:[UIImage imageNamed:@"yelp"]];
    
    // Setting ratings image
    [cell.ratingImage sd_setImageWithURL:[NSURL URLWithString:model.ratingURL]];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Row Clicked");
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
