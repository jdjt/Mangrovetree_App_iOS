//
//  FMLocationManager.h
//  FMMapKit
//
//  Created by fengmap on 16/9/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMManager.h"
#import "FMKGeometry.h"

@class FMLocationBuilderInfo;
@class FMKImageMarker;
@class FMMangroveMapView;


@protocol FMLocationManagerDelegate <NSObject>



/**
 判断两点距离是否小于设定值

 @param result 结果 小于返回YES
 @param distance 实际距离
 */
- (void)testDistanceWithResult:(BOOL)result distance:(double)distance;


/**
 更新添加的标注物位置

 @param mapCoord 地图坐标
 @param macAddress MAC地址
 */
- (void)updateLocPosition:(FMKMapCoord)mapCoord macAddress:(NSString *)macAddress;

@end


@interface FMLocationManager : NSObject


+ (instancetype)shareLocationManager;

@property (nonatomic, weak) id<FMLocationManagerDelegate>delegate;


/**
 添加的MAC集合
 */
@property (nonatomic, readonly) NSArray * macs;

/**
 是否正在呼叫服务
 */
@property (nonatomic, readonly) BOOL isCallingService;
/**
 设置地图视图(危险 慎用)

 @param mapView 当前显示的地图视图
 */
- (void)setMapView:(FMMangroveMapView *)mapView;

/**
 *  添加定位信息图片标注物
 *
 *  @param loc 定位信息
 */
- (void)addLocOnMap:(FMLocationBuilderInfo *)loc;
/**
 *  删除定位信息图片标注物
 *
 *  @param loc 定位信息
 */
- (void)removeLocOnMap:(FMLocationBuilderInfo *)loc;


/**
 判断两点之间的距离是否大于设定阈值

 @param location1 位置点1
 @param location2 位置点2
 @param distance  设定距离

 @return 比较结果 小于 返回YES
 */
- (void)testDistanceWithLocation1: (FMLocationBuilderInfo *)location1 location2: (FMLocationBuilderInfo *)location2 distance: (double)distance;


/**
 停止两点之间位置判断
 */
- (void)stopTestDistance;

@end
