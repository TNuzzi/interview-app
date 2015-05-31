//
//  YelpAPIService.m
//
//  Adapted by Tony Nuzzi on 7/25/15
//  Originally Created by Max Campolo on 7/16/14.
//  https://github.com/maxcampolo/WeHungry

#import "YelpAPIService.h"
#import "OAuthAPIConstants.h"
#import "CoffeeshopModel.h"

// Yelp search URL
#define YELP_SEARCH_URL @"http://api.yelp.com/v2/search"

// Harding for now but could turn into a filter option
#define SEARCH_RESULT_LIMIT 20

@implementation YelpAPIService

#pragma mark Yelp API Helpers

-(void)findNearByCoffeshopsByLocation:(NSString *) location aLatitude:(CLLocationDegrees)latitude
                         andLongitude:(CLLocationDegrees)longitude {
    
    // Constructing search URL string (https://www.yelp.com/developers/documentation/v2/search_api)
    // term = search term
    // location = location to search (can be name or postalCode)
    // cll = latitude and longitude
    // limit = limits the number of results returned
    // sort = sort by distance
    NSString* urlString = [[NSString stringWithFormat:@"%@?term=%@&location=%@&cll=%f,%f&limit=%i&sort=1",
                 YELP_SEARCH_URL,
                 @"coffee",
                 location,
                 latitude, longitude,
                 SEARCH_RESULT_LIMIT] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Initialize URL object
    NSURL *URL = [NSURL URLWithString:urlString];
    
    // Prepare OAuth call
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
                                                    secret:OAUTH_CONSUMER_SECRET];
    OAToken *token = [[OAToken alloc] initWithKey:OAUTH_TOKEN
                                           secret:OAUTH_TOKEN_SECRET];
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    
    [request prepare];
    
    // Initialize URLConnection
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // Prepare connection response to receive data
    if (conn) {
        self.urlRespondData = [NSMutableData data];
    }
}


#pragma mark Connection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.urlRespondData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.urlRespondData appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSDictionary *userInfo = [error userInfo];
    NSString *errorString = [[userInfo objectForKey:NSUnderlyingErrorKey] localizedDescription];
    
    // Log error to console
    NSLog(@"%@", errorString);
    
    // Initialize alert controller
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to connect to Yelp server." preferredStyle:UIAlertControllerStyleAlert];
    
    // Ok Action button
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    // Show Alert controller
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *e = nil;
    
    NSDictionary *resultResponseDict = [NSJSONSerialization JSONObjectWithData:self.urlRespondData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&e];
    if (self.resultArray && [self.resultArray count] > 0) {
        [self.resultArray removeAllObjects];
    }
    
    if (!self.resultArray) {
        self.resultArray = [[NSMutableArray alloc] init];
    }
    
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
    */
    if (resultResponseDict && [resultResponseDict count] > 0) {
        if ([resultResponseDict objectForKey:@"businesses"] &&
            [[resultResponseDict objectForKey:@"businesses"] count] > 0) {
            for (NSDictionary *coffeeshopDict in [resultResponseDict objectForKey:@"businesses"]) {
                CoffeeshopModel *coffeeshopObj = [[CoffeeshopModel alloc] init];
                coffeeshopObj.name = [coffeeshopDict objectForKey:@"name"];
                coffeeshopObj.imageURL = [coffeeshopDict objectForKey:@"image_url"];
                coffeeshopObj.ratingURL = [coffeeshopDict objectForKey:@"rating_img_url"];
                coffeeshopObj.mobileURL = [coffeeshopDict objectForKey:@"mobile_url"];
                coffeeshopObj.rating = [coffeeshopDict objectForKey:@"rating"];
                coffeeshopObj.reviewCount = [coffeeshopDict objectForKey:@"review_count"];
                coffeeshopObj.address = [[[coffeeshopDict objectForKey:@"location"] objectForKey:@"display_address"] componentsJoinedByString:@", "];
                coffeeshopObj.phone = [coffeeshopDict objectForKey:@"display_phone"];
                coffeeshopObj.latitude = [[[[coffeeshopDict objectForKey:@"location"] objectForKey:@"coordinate"] objectForKey:@"latitude"] doubleValue];
                coffeeshopObj.longitude = [[[[coffeeshopDict objectForKey:@"location"] objectForKey:@"coordinate"] objectForKey:@"longitude"] doubleValue];
                
                [self.resultArray addObject:coffeeshopObj];
            }
        }
    }
    
    [self.delegate loadResultWithDataArray:self.resultArray];
}

@end
