//
//  FMNaviAnalyserTool.h
//  mgmanager
//
//  Created by fengmap on 16/8/25.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKGeometry.h"

typedef void(^ReturnNaviResultBlock)(NSArray * naviResult, NSString * mapID);

@interface FMNaviAnalyserTool : NSObject

@property (nonatomic, copy) ReturnNaviResultBlock returnNaviResult;//返回路径规划结果和对应的地图ID

//key:value mapID:NSArray
@property (nonatomic, strong) NSDictionary * naviResult;//路径规划结果
@property (nonatomic, assign) BOOL hasStartNavi;
@property (nonatomic, assign) BOOL planNavi;//计划开启导航
@property (nonatomic, assign) FMKMapCoord startMapCoord;//路径规划起点
@property (nonatomic, assign) FMKMapCoord endMapCoord;//路径规划终点

@property (nonatomic, strong) NSMutableArray * mapIDs;//路径规划经过的地图ID

@property (nonatomic, copy) NSString * endName;//终点模型的名称 在搜索时用到

/**
 路径规划总长度 当路径规划失败时，长度为两点间直线距离
 */
@property (nonatomic, readonly) float naviLength;

+ (instancetype)shareNaviAnalyserTool;

/**
 *  路径规划
 *
 *  @param startMapCoord 起点地图坐标
 *  @param endCoord      终点地图坐标
 *
 *  @return 路径规划结果值
 */
- (BOOL)naviAnalyseByStartMapCoord:(FMKMapCoord)startMapCoord
					   endMapCoord:(FMKMapCoord)endCoord;

/**
 *  根据定位点坐标返回剩余路程
 *
 *  @param mapCoord 定位点坐标 约束过的坐标
 *  @param index    约束结果index
 *
 *  @return 剩余路程
 */
- (double)calSurplusLengthByMapCoord:(FMKMapCoord)mapCoord index:(int)index;

/**
 *  室外地图路径规划
 *
 *  @param startCoord 起点
 *  @param endCoord   终点
 *
 *  @return 路径规划结果
 */
- (NSArray * )outdoorMapRouteFuncNaviByStartCoord:(FMKGeoCoord)startCoord endCoord:(FMKGeoCoord)endCoord;

- (double)calTwoPointLength:(FMKMapPoint)currentPoint lastMapPoint:(FMKMapPoint)lastMapPoint;
@end
