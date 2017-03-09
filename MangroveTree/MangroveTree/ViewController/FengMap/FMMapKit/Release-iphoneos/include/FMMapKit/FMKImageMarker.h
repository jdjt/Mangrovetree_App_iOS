//
//  FMKImageMarkerNode.h
//  FMMapKit
//
//  Created by FengMap on 15/5/23.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMKNode.h"

#import "FMKNodeAnimator.h"

/**
 *  图片位于地图上的位置
 */
typedef NS_ENUM(NSInteger, FMKImageMarkerOffsetMode){
    /**
     *  位于建筑模型之上
     */
    FMKImageMarker_MODELTOP=0,
    /**
     *  位于地面之上
     */
    FMKImageMarker_OVEREXTENT,
    
    /**
     *  用户自定义
     */
    FMKImageMarker_USERDEFINE
};

typedef NS_ENUM(NSInteger, FMKImageMarkerDepthMode)
{
    FMKImageMarker_DEPTH_LESS_PASS      = 0,
    FMKImageMarker_DEPTH_ALAWYS_PASS
};

/**
 * @brief 用户自定义图片点位置，
 * 可用一张自定义图片进行模型等的描述
 */
@interface FMKImageMarker : FMKNode

/**
 *  使用UIImage初始化
 *
 *  @param image    UIImage对象
 *  @param mapCoord 地图地理坐标
 *
 *  @return 图片标注对象
 */
- (instancetype)initWithImage:(UIImage *)image
                        Coord:(FMKMapPoint)mapCoord;

/**
 *  需要使用png格式的图片；
 *  默认图片路径为nil
 *  若不设置图片路径，则此处可设图片全路径
 *
 *  @param name     图片名
 *  @param mapCoord 地理坐标
 *
 *  @return 图片标注对象
 */
- (instancetype)initWithImageName:(NSString *)name
                            Coord:(FMKMapPoint)mapCoord;

/**
 *  设置图片平铺
 */
- (void)setImageMarkerTile;

/**
 *  设置平铺图片的位移
 *
 *  @param mapPoint 地图坐标
 */
//- (void)setLayerCoord:(FMKMapPoint)mapPoint;

@property (nonatomic, assign)FMKMapPoint layerCoord;

- (FMKMapPoint)getMapPointByLayerCoord:(FMKMapPoint)layerCoord;

/// 添加的图片
@property (nonatomic,readonly)      UIImage*               image;
/// 图片资源名,此版本图片不支持修改
@property (nonatomic,readonly)      NSString*              imageName;
/// 标注物地理坐标中心点
@property (nonatomic,assign)        FMKMapPoint            mapCoord;
/// 图片大小
@property (nonatomic,assign)        CGSize                 imageSize;
/// 选中状态
@property (nonatomic,assign)        BOOL                   selected;
/// 隐藏属性
@property (nonatomic,assign)        BOOL                   hidden;
/// 自定义图片标注所在的位置
@property (nonatomic,assign)        FMKImageMarkerOffsetMode offsetMode;
/// 设置图片标注物所在位置的高度偏移量
@property (nonatomic,assign)        float                 imageOffset;
///节点动画对象
@property (nonatomic,strong)        FMKNodeAnimator * nodeAnimator;
///图片的旋转角度
@property (nonatomic,assign)        float                   angle;

@property (nonatomic,assign)        FMKImageMarkerDepthMode depthMode;
@end






