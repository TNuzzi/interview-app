//
//  YelpAPIService.m
//
//  Adapted by Tony Nuzzi on 7/25/15
//  Originally Created by Max Campolo on 7/16/14.
//  https://github.com/maxcampolo/WeHungry

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"

@protocol YelpAPIServiceDelegate <NSObject>
    -(void)loadResultWithDataArray:(NSArray *)resultArray;
@end

@interface YelpAPIService : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, strong) NSMutableData *urlRespondData;
@property(nonatomic, strong) NSString *responseString;
@property(nonatomic, strong) NSMutableArray *resultArray;

@property (weak, nonatomic) id <YelpAPIServiceDelegate> delegate;

- (void)findNearByCoffeshopsByLocation:(NSString *) postalCode aLatitude:(CLLocationDegrees)latitude
andLongitude:(CLLocationDegrees)longitude;

@end
