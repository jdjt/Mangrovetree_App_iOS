//
//  FMKModelLayer.h
//  FMMapKit
//
//  Created by FengMap on 15/8/18.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import "FMKLayer.h"

@class FMKModel;

/**
 * 地图模型层，用于标注地图楼层上的模型层
 * 可通过地图map节点获取
 */
@interface FMKModelLayer : FMKLayer

/**
 *  初始化模型层，暂不支持模型层创建
 *
 *  @param groupID 楼层ID
 *
 *  @return 地图模型层对象
 */
- (instancetype)initWithGroupID:(NSString *)groupID;

/**
 *  model所在的groupID
 */
@property (readonly) NSString* groupID;


/**
 *  根据fid查找model
 *
 *  @param fid 蜂鸟fid,可通过数据查询可获得
 *
 *  @return FMKModel
 */
- (FMKModel *)queryModelByFID:(NSString *)fid;

/**
 *  根据模型类型查找model
 *
 *  @param type 蜂鸟type,可通过数据查询
 *
 *  @return FMKModel
 */
- (NSArray *)queryModelByType:(NSString *)type;

@end
