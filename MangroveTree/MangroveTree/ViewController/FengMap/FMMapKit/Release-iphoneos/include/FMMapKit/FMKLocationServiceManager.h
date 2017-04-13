//
//  FMKLocationServiceManager.h
//  FMMapKit
//
//  Created by fengmap on 16/11/23.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKGeometry.h"

@protocol FMKLocationServiceManagerDelegate <NSObject>


/**
 位置回调

 @param mapCoord 位置
 */
- (void)didUpdatePosition:(FMKMapCoord)mapCoord success:(BOOL)success;

/**
 方向回调

 @param heading 角度
 */
- (void)didUpdateHeading:(double)heading;

/**
 WIFI信息

 @param time 时间差
 */
- (void)wifiInfoTime:(NSTimeInterval)time wifiStatus:(BOOL)wifiStatus GPSHorizontalAccuracy:(float)GPSHorizontalAccuracy wifiMaxRssi:(int)MaxRssi uMapID:(int)uMapID;

@end


@interface FMKLocationServiceManager : NSObject

@property (nonatomic, weak) id<FMKLocationServiceManagerDelegate>delegate;

/**
 当前定位位置
 */
@property (nonatomic, readonly) FMKMapCoord currentMapCoord;//当前定位位置

/**
 上传位置开关  默认开启
 */
@property (nonatomic, assign) BOOL enableUploadPosition;

+ (instancetype)shareLocationServiceManager;

/**
 开启定位服务  同时开启GPS和wifi定位服务 此处地图数据路径为室外地图数据路径
 */
- (void)startLocateWithMacAddress:(NSString *)macAddress mapPath:(NSString *)mapPath;

/**
 停止定位服务
 */
- (void)stopLocationService;
///重新开始定位服务
- (void)restartLocationService;

@end
