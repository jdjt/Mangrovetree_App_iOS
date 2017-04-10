//
//  FMNaviAnalyser.h
//  FMMapKit
//
//  Created by FengMap on 15/6/1.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKGeometry.h"

/**
 *  路径规划类型
 */
typedef NS_ENUM(int, FMKNaviModule)
{
    /**
     * 最短
     */
    MODULE_SHORTEST = 1,
    
    /**
     * 最优
     */
    MODULE_BEST = 2,
};

/**
 * 路径计算的返回值。
 */
typedef NS_ENUM(int, FMKRouteCalculateResultType)
{
    IROUTE_DATA_LOST = -3,               ///地图数据不存在
    IROUTE_DATABASE_ERROR = -2,          ///数据库出错
    IROUTE_PARAM_ERROR = -1,             ///数据错误
    IROUTE_SUCCESS = 1,                  ///成功
    IROUTE_FAILURE_NO_FMDBKERNEL = 2,    ///与数据无关的错误
    IROUTE_FAILURE_TOO_CLOSE = 3,        ///失败，起点和终点太近
    IROUTE_FAILURE_NO_START = 4,         ///失败，没有起点所在层的数据
    IROUTE_FAILURE_NO_END = 5,           ///失败，没有终点所在层的数据
    IROUTE_FAILURE_NO_STAIR_FLOORS = 6,  ///失败，没有电梯（扶梯）进行跨楼路径规划
    IROUTE_FAILURE_NOTSUPPORT_FLOORS = 7,///失败，不支持跨楼层导航
    IROUTE_FAILED_CANNOT_CALCULATE = 8,  ///不能计算
    IROUTE_SUCCESS_NO_RESULT = 9         ///没有结果
};

typedef NS_ENUM(NSInteger, FMKMultiRouteCalcType)
{
	FMKMULTIROUTE_NONE = 0,//地图数据或路径数据初始化错误
	FMKMULTIROUTE_SUCCESS,//成功
	FMKMULTIROUTE_FAILED_ERROR_PARA,
	FMKMULTIROUTE_FAILED_NO_NAVIDATAS,
	FMKMULTIROUTE_FAILED_CANNOT_ARRIVE
	
};

/*
 *  路径规划分析
 */
@class FMKNaviResult;
@protocol FMKNaviAnalyserDelegate;

@interface FMKNaviAnalyser : NSObject

/**
 *  通过mapID初始化路径分析
 *
 *  @param mapID mapID
 *
 *  @return 路径分析对象
 */
- (instancetype)initWithMapID:(NSString *)mapID;

/**
 *  通过地图数据路径初始化路径分析
 *
 *  @param dataPath 地图数据路径
 *
 *  @return 路径分析对象
 */
- (instancetype)initWithMapPath:(NSString *)dataPath;

/**
 *  跨地图路径规划
 *
 *  @param startMapPath 起点所在地图数据路径
 *  @param endMapPath   终点所在地图数据路径
 *
 *  @return 路径分析对象
 */
- (instancetype)initWithStartMapPath:(NSString *)startMapPath endMapPath:(NSString *)endMapPath;

/**
 *  代理
 */
@property (nonatomic,weak)  id<FMKNaviAnalyserDelegate> delegate;

/**
 *  路径规划分析
 *
 *  @param start           路径规划起点
 *  @param end             路径规划终点
 *  @param module          路径规划类型
 *
 *  @return 路径规划计算结果
 */
- (FMKRouteCalculateResultType)analyseRouteWithStartCoord:(FMKGeoCoord)start
                                                 endCoord:(FMKGeoCoord)end
                                                     type:(FMKNaviModule)module;

/**
 *  路径规划分析
 *
 *  @param start           路径规划起点
 *  @param end             路径规划终点
 *  @param module          路径规划类型
 *  @param naviResults     路径规划结果，对象为FMKNaviResult型对象
 *
 *  @return 路径规划计算结果
 */
- (FMKRouteCalculateResultType)analyseRouteWithStartCoord:(FMKGeoCoord)start
                                                      end:(FMKGeoCoord)end
                                                     type:(FMKNaviModule)module
                                              routeResult:(NSMutableArray **)naviResults;

/**
 *  跨地图路径规划 若使用跨地图路径规划，分析对象需使用跨地图路径分析初始化方法
 *
 *  @param start          起点
 *  @param end            终点
 *  @param startMapResult 起点所在地图结果
 *  @param endMapResult   终点所在地图结果
 *
 *  @return 路径规划结果
 */
- (FMKMultiRouteCalcType)analyseRouteWithStartCoord:(FMKMapCoord)startCoord
												end:(FMKMapCoord)endCoord
									 startMapResult:(NSMutableArray **)startMapResult
									   endMapResult:(NSMutableArray **)endMapResult;

@end

@protocol FMKNaviAnalyserDelegate <NSObject>

@optional

/**
 *  同层结果计算，路径坐标集合
 *
 *  @param coords 数组中为FMKMapPoint的NSValue类型数据
 */
- (void)getFloorNaviGeoCoords:(NSArray *)coords inFloor:(NSString *)groupID;

/**
 * 同层结果计算，路径长度
 */
- (void)getFloorRouteLength:(double)length;

/**
 * 跨层结果计算，获取经过楼层的id
 */
- (void)getMultiFloorNaviGroupIDs:(NSArray *)gids;

/**
 * 跨层结果计算，获取各层路径的长度
 */
- (void)getMultiFloorRouteLength:(double)length inFloor:(NSString *)groupID;

/**
 *  跨层结果计算，返回路径上的点
 *  @param coords 数组中为FMKMapPoint的NSValue类型数据
 */
- (void)getMultiFloorNaviGeoCoords:(NSArray *)coords inFloor:(NSString *)groupID;

/**
 *  跨层路径总长度
 */
- (void)getMultiFloorTotalLength:(double)length;



/**
 *  同层结果计算，路径坐标集合
 *
 *  @param coords 数组中为FMKMapPoint的NSValue类型数据
 */
- (void)getFloorNaviGeoCoords:(NSArray *)coords inFloor:(NSString *)groupID mapID:(NSString *)mapID;

/**
 * 同层结果计算，路径长度
 */
- (void)getFloorRouteLength:(double)length mapID:(NSString *)mapID;

/**
 * 跨层结果计算，获取经过楼层的id
 */
- (void)getMultiFloorNaviGroupIDs:(NSArray *)gids mapID:(NSString *)mapID;

/**
 * 跨层结果计算，获取各层路径的长度
 */
- (void)getMultiFloorRouteLength:(double)length inFloor:(NSString *)groupID mapID:(NSString *)mapID;

/**
 *  跨层结果计算，返回路径上的点
 *  @param coords 数组中为FMKMapPoint的NSValue类型数据
 */
- (void)getMultiFloorNaviGeoCoords:(NSArray *)coords inFloor:(NSString *)groupID mapID:(NSString *)mapID;

/**
 *  跨层路径总长度
 */
- (void)getMultiFloorTotalLength:(double)length mapID:(NSString *)mapID;


@end





