//
//  FMKImageMarkerLayer.h
//  FMMapKit
//
//  Created by FengMap on 15/6/2.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import "FMKLayer.h"

@class FMKImageMarker;


typedef NS_ENUM(NSInteger, FMKImageCoverCalcMode)
{
	FMKIMAGE_COVERCALC_NONE=0,
	FMKIMAGE_COVERCALC_NODEADDSEQUENCE
};


/**
 * 地图图片标注层节点，用于添加地图的图片标注
 * 同一楼层可添加多个图片层
 */
@interface FMKImageLayer : FMKLayer

/**
 *  在某层上初始化图片层
 *
 *  @param groupID 楼层ID
 *
 *  @return 图片层对象
 */
- (instancetype)initWithGroupID:(NSString *)groupID;

/**
 * 图层所在组的ID
 */
@property (nonatomic, readonly)   NSString *groupID;

/**
 图片避让计算模式
 */
@property (nonatomic, assign) FMKImageCoverCalcMode imageCoverCalcMode;

/**
 *  添加图片标注物
 *
 *  @param imageMarker 图片标注对象
 */
- (void)addImageMarker:(FMKImageMarker *)imageMarker animated:(BOOL)animated;

/**
 *  获取图片元素
 *
 *  @param tag 图片唯一标识
 *
 *  @return 图片标注对象
 */
- (FMKImageMarker *)imageMarkerWithTag:(NSInteger)tag;

/**
 *  删除指定tag的标注物
 *
 *  @param imageMarker 图片标注对象
 */
- (void)removeImageMarker:(FMKImageMarker *)imageMarker;

/**
 * 移除所有标注物
 */
- (void)removeAllImageMarker;

@end

