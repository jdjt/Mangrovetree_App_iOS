//
//  FMKLineLayer.h
//  FMMapKit
//
//  Created by FengMap on 15/8/24.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import "FMKLayer.h"

@class FMKLineMarker;

/**
 *  地图线层标注层
 *  每张地图的线标注层只有一个，暂不支持创建
 *  可通过地图map节点获取
 */
@interface FMKLineLayer : FMKLayer

/**
 *  添加线
 *
 *  @param lineMarker 地图线对象
 */
- (void)addLineMarker:(FMKLineMarker *)lineMarker;

/**
 *  删除线
 *
 *  @param lineMarker 地图线对象
 */
- (void)removeLine:(FMKLineMarker *)lineMarker;

/**
 *  删除所有线对象
 */
- (void)removeAllLine;


@end
