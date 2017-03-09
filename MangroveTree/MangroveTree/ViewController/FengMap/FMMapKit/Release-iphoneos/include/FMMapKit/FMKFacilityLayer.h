//
//  FMKFacilityLayer.h
//  FMMapKit
//
//  Created by FengMap on 15/6/24.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import "FMKLayer.h"

@class FMKFacility;

/**
 * 地图公共设施层，该层暂不支持添加
 * 可通过地图map节点获取
 */
@interface FMKFacilityLayer : FMKLayer

/**
 *  初始化公共设施层
 *
 *  @param groupID 楼层ID
 *
 *  @return 公共设施层对象
 */
- (instancetype)initWithGroupID:(NSString *)groupID;

/**
 *  所在的楼层ID
 */
@property (readonly) NSString* groupID;


/**
 *  根据设施类型返回
 *
 *  @param type 蜂鸟type,可通过数据查询
 *
 *  @return 数组中为FMKFacility类型对象
 */
- (NSArray *)queryFacilityByType:(NSString *)type;

@end
