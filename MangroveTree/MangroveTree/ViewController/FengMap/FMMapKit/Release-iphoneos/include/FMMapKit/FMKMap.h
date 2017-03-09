//
//  FMKScene.h
//  FMMapKit
//
//  Created by FengMap on 15/8/20.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMKView;
@class FMKMapInfo;

@class FMKGroup;

@class FMKLayer;
@class FMKLineLayer,FMKLocationLayer; //只读层，单个
@class FMKFacilityLayer,FMKModelLayer,FMKTextLayer,FMKExtentLayer,FMKLabelLayer,FMKExternalModelLayer;     //只读层，多个
@class FMKImageLayer,FMKTextLayer,FMKGroundLayer;


#import "FMKAnimatorEnableController.h"

@interface FMKMap : NSObject


- (instancetype)initWithPath:(NSString *)dataPath;
@property (nonatomic,readonly) NSString* dataPath;

/**
 *  内部关联指针
 */
@property (nonatomic,assign)  long pointer;

/**
 *  地图ID
 */
@property (nonatomic,copy)     NSString* ID;
/**
 *  楼层名数组
 */
@property (nonatomic,readonly) NSArray * names;
/**
 *  地图信息
 */
@property (nonatomic,readonly) FMKMapInfo* info;

/**
 *  地图添加线管理层
 */
@property (nonatomic,readonly) FMKLineLayer*      lineLayer;

/**
 *  地图定位管理层
 */
@property (nonatomic,readonly) FMKLocationLayer*  locateLayer;

/**
 *  获取楼层管理对象
 *
 *  @param groupID 楼层ID
 *
 *  @return 楼层管理对象
 */
- (FMKGroup*)getGroupWithGroupID:(NSString *)groupID;

/**
 *  获取地图POI点管理层
 *
 *  @param groupID poi层所在的group层
 *
 *  @return POI层管理对象
 */
- (FMKFacilityLayer *)getFacilityLayerWithGroupID:(NSString *)groupID;

/**
 *  获取地图Model管理层对象
 *
 *  @param groupID model层所在的group层
 *
 *  @return model层管理对象
 */
- (FMKModelLayer *)getModelLayerWithGroupID:(NSString *)groupID;

/**
 *  获取地图text层管理对象
 *
 *  @param groupID text层所在group层
 *
 *  @return text层管理对象
 */
- (FMKLabelLayer *)getLabelLayerWithGroupID:(NSString *)groupID;

/**
 *  获取地图的ground层管理对象
 *
 *  @param groupID ground层所在的Group层
 *
 *  @return FMKGroundLayer
 */
- (FMKGroundLayer *)getGroundLayerWithGroupID:(NSString *)groupID;

/**
 *  获取地图的外部模型层
 *
 *  @param groupID 楼层ID
 *
 *  @return 外部模型层管理对象
 */
- (FMKExternalModelLayer *)getExternalModelLayerWithGroupID:(NSString *)groupID;

/**
 *  获取对应group层下的已添加image层对象
 *
 *  @param groupID image层所在的group层
 *
 *  @return image层管理对象
 */
- (NSArray *)getImageLayerWithGroupID:(NSString *)groupID;

/**
 *  获取对应楼层下的已添加的文本图层
 *
 *  @param groupID 楼层ID
 *
 *  @return 对应楼层下的文本图层
 */
- (NSArray *)getTextLayerWithGroupID:(NSString *)groupID;

/**
 *  获取对应楼层下的底图图层
 *
 *  @param groupID 底图所在的楼层ID
 *
 *  @return 底图图层对象
 */
- (FMKExtentLayer *)getExtentLayerWithGroupID:(NSString *)groupID;

/**
 *  添加图层
 *
 *  @param layer 地图可添加层对象
 */
- (void)addLayer:(FMKLayer *)layer;

/**
 *  删除图层
 *
 *  @param layer 地图可删除层对象
 */
- (void)removeLayer:(FMKLayer *)layer;

/**
 *  通过层标识获取层管理对象
 *
 *  @param tag 唯一的层标识
 *
 *  @return 返回层对象
 */
- (FMKLayer *)layerWithTag:(NSInteger)tag;

/**
 *  删除所有图片标注层
 */
- (void)removeAllImageLayer;


@end
