//
//  FMKLocationService.h
//  mgmanager
//
//  Created by fengmap on 16/8/19.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FMKGeometry.h"
#import "FMKNaviStruct.h"
#import "FMKNaviContraint.h"
@class DevicePositionInfo;

@protocol FMKLocationServiceDelegate <NSObject>

@optional
/**
 *  更新位置
 *
 *  @param mapPoint fengmap地图坐标
 */
- (void)didUpdateLocation:(FMKMapPoint)mapPoint location:(CLLocation *)location isIndoor:(BOOL)isIndoor;

/**
 *  更新设备朝向
 *
 *  @param heading 设备朝向
 */
- (void)didUpdateHeading:(double)heading;

/**
 *  更新WIFI定位坐标返回
 *
 *  @param devicePositionInfo 设备的位置信息
 */
- (void)didUpdateWifiLocation:(DevicePositionInfo *)devicePositionInfo isOutdoor:(BOOL)isOutdoor;



- (void)wifiInfoTime:(NSTimeInterval)time wifiStatus:(BOOL)wifiStatus GPSHorizontalAccuracy:(float)GPSHorizontalAccuracy wifiMaxRssi:(int)MaxRssi uMapID:(int)uMapID;

@end

@interface FMKLocationService : NSObject

@property (nonatomic, weak)id<FMKLocationServiceDelegate>delegate;
@property (nonatomic, assign) BOOL isGPSLocating;
@property (nonatomic, assign) BOOL isWIFILocating;
//@property (nonatomic, assign) FMKMapCoord startMapCoord;
//@property (nonatomic, assign) FMKMapCoord endMapCoord;
@property (nonatomic, assign) BOOL isLocating;

@property (nonatomic, assign) BOOL isIndoor;
//@property (nonatomic, assign) BOOL isOutdoor;

+ (instancetype)shareLocationService;


/**
 网络状况判断

 @return 是否有WIFI网络链接
 */
+ (BOOL)currentNetStatus;

/**
 *  开始GPS定位
 */
- (void)startGPSLocation;

/**
 *  停止GPS定位
 */
- (void)stopGPSLocation;

/**
 *  开始WIFI定位
 *
 *  @param macAddr MAC地址
 */
- (void)startWifiLocationWithMacAddr:(NSString *)macAddr;
/**
 *  停止WIFI定位
 */
- (void)stopWifiLocation;


- (FMKNaviContraintPara)naviConstraintWithLastMapPoint:(FMKMapPoint)lastMapPoint currentMapPoint:(FMKMapPoint)currentMapPoint;

/**
 84坐标转墨卡托投影坐标

 @param lonLat 经纬度

 @return 墨卡托投影坐标
 */
-(FMKMapPoint )lonLat2Mercator:(FMKMapPoint) lonLat;

@end
