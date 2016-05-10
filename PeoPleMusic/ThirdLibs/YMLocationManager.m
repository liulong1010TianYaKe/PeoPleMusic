//
//  YMLocationManager.m
//  PeoPleMusic
//
//  Created by long on 5/5/16.
//  Copyright © 2016 zhuniT All rights reserved.
//

#import "YMLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>

#define KAppKey @"8783f824f672b089703e7dd5b5552d27"

#define LocationTimeout 3  //   定位超时时间，可修改，最小2s
#define ReGeocodeTimeout 3 //   逆地理请求超时时间，可修改，最小2s
@interface YMLocationManager ()<AMapLocationManagerDelegate>

@property (nonatomic,strong) AMapLocationManager *aMapLocationManager;
@end
@implementation YMLocationManager

+ (instancetype)shareManager{
    static YMLocationManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[YMLocationManager alloc] init];
        [share configureAPIKey];
    });
    
    return share;
}

- (void)configureAPIKey
{
  
    [[AMapLocationServices sharedServices] setApiKey:KAppKey];
    
    self.aMapLocationManager = [[AMapLocationManager alloc] init];
    self.aMapLocationManager.delegate = self;
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.aMapLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.aMapLocationManager.locationTimeout = LocationTimeout;
    //   逆地理请求超时时间，可修改，最小2s
    self.aMapLocationManager.reGeocodeTimeout = ReGeocodeTimeout;
    [self.aMapLocationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.aMapLocationManager setAllowsBackgroundLocationUpdates:YES];
    
}

- (void)cleanUpAction
{
    [self.aMapLocationManager stopUpdatingLocation];
    
    [self.aMapLocationManager setDelegate:nil];
}
- (void)startLocotion:(locationgCompletionBlock)completionblock{
    [self.aMapLocationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                if (completionblock) {
                    completionblock(location.coordinate.longitude,location.coordinate.latitude,error);
                }
                return;
            }
        }
        
        if (completionblock) {
            completionblock(location.coordinate.longitude,location.coordinate.latitude,nil);
        }

    }];
}
#pragma mark -------------------
#pragma mark - AMapLocationManagerDelegate
/**
 *  当定位发生错误时，会调用代理的此方法。
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    
}
/**
 *  定位权限状态改变时回调函数
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
}

@end
