//
//  LocationModel.m
//  JHCommunityClient
//
//  Created by xixixi on 16/4/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//  使用高德地图定位

#import "LocationModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreLocation/CoreLocation.h>
@implementation LocationModel
{
    AMapLocationManager *locationManager;//一次性定位
}

#pragma mark - 一次性定位
-(void)location
{
    //******高德定位sdk,一次性定位******//
    [AMapLocationServices sharedServices].apiKey = GAODE_KEY;
    locationManager = [[AMapLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);

            if (error.code == AMapLocationErrorLocateFailed){
            }
            return ;
        }
        NSLog(@"location:%@", location);
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode.citycode);
            
        }else{
            
        }
    }];
}

@end
