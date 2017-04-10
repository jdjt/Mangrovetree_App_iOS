//
//  FMSearchAPI.h
//  FMMapKit
//
//  Created by FengMap on 15/5/15.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKGeometry.h"
#import "FMKSearchObj.h"
//@class FMKSearchRequest;
//@class FMKSearchResult;
@protocol FMKSearchAnalyserDelegate;

/**
 * fengmap的查询功能
 * 用于查询fengmap基础数据
 * 基础数据包括model poi等
 */
@interface FMKSearchAnalyser : NSObject

/**
 *  实现了FMKSearchAnalyserDelegate协议的类指针
 */
@property (nonatomic,weak) id<FMKSearchAnalyserDelegate> delegate;

/**
 *  通过mapID初始化查询
 *
 *  @param mapID 蜂鸟mapID
 *
 *  @return FMKSearchAnalyser类型对象
 */
- (instancetype)initWithMapID:(NSString *)mapID;

/**
 *  通过地图数据初始化查询
 *
 *  @param 蜂鸟地图数据路径
 *
 *  @return FMKSearchAnalyser类型对象
 */
- (instancetype)initWithDataPath:(NSString *)dataPath;


/**
 *  获取所有gid
 */
@property (nonatomic,readonly) NSArray* groupIDs;

/**
 *  所有楼层名
 */
@property (nonatomic,readonly) NSArray* groupNames;

/**
 *  查询所有模型信息
 *
 *  @param groupID 楼层号
 *
 *  @return 结果返回FMKModelSearchResult对象的数组
 */
- (NSArray *)getAllModelsWithGroupID:(NSString *)groupID;
/**
 *  查询所有公共设施信息
 *
 *  @param groupID 楼层号
 *
 *  @return 结果返回FMKMFacilitySearchResult对象的数组
 */
- (NSArray *)getAllFacilityWithGroupID:(NSString *)groupID;

/**
 *  通过fid进行查询
 *
 *  @param searchRequest FMKSearchRequest类型或子类的请求对象
 */
- (void)executeFMKSearchRequestByFID:(FMKSearchRequest *)searchRequest;


- (void)executeFMKSearchRequestByMapPoint:(FMKModelSearchRequest *)searchRequest;

/**
 *  通过关键字进行查询
 *
 *  @param searchRequest FMKSearchRequest类型或子类的请求对象
 */
- (void)executeFMKSearchRequestByKeyWords:(FMKSearchRequest *)searchRequest;
/**
 *  通过类型进行查询
 *
 *  @param searchRequest FMKSearchRequest类型或子类的请求对象
 */
- (void)executeFMKSearchRequestByType:(FMKSearchRequest *)searchRequest;

/**
 *  根据范围查询模型
 *
 *  @param request 查询请求
 */
- (void)executeFMKSearchRequestByMapPoints:(FMKExternalModelSearchRequest *)request;

@end

@class FMKModelSearchRequest;
@class FMKFacilitySearchRequest;
@class FMKExternalModelSearchRequest;

@protocol FMKSearchAnalyserDelegate <NSObject>

@optional

/**
 *  查询模型结果返回
 *
 *  @param request     模型查询请求
 *  @param resultArray 模型查询结果，数组中为FMKModelSearchResult型对象
 */
- (void)onModelSearchDone:(FMKModelSearchRequest *)request result:(NSArray *)resultArray;

/**
 *  查询外部模型返回
 *
 *  @param request     外部模型查询请求
 *  @param resultArray 外部模型查询结果
 */
- (void)onExternalModelSearchDone:(FMKExternalModelSearchRequest *)request result:(NSArray *)resultArray;

/**
 *  查询公共设施结果返回
 *
 *  @param request     公共设施查询请求
 *  @param resultArray 公共设施查询结果，数组中为FMKFacilitySearchResult型对象
 */
- (void)onFacilitySearchDone:(FMKFacilitySearchRequest *)request result:(NSArray *)resultArray;

@end


