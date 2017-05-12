//
//  FMKLineNode.h
//  FMMapKit
//
//  Created by FengMap on 15/5/25.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMKNode.h"

/**
 *  地图的线节点，用于添加地图上的线
 */
typedef NS_ENUM(NSInteger,FMKLineType)
{
    FMKLINE_FULL=0,
    
    FMKLINE_DOTTED,     ///点线 1000100010001000, 表示实际画线的点
    //.  .  .  .  .  .  .  .  .  .  .  .  .  .
    FMKLINE_DOTDASH,    ///点划线    1111111111100100  dot dash
    //____ . ____ . _____ . _____. _____
    FMKLINE_CENTER,     ///中心线    1111111111001100  centre line
    //_____ _ _____ _ _____ _ _____ _ _____
    FMKLINE_DASHED,     ///虚线  1111110011111100   dashed
    //____  ____  ____  ____  ____  ____  ____
    FMKLINE_DOUBLEDOTDASH,      ///双点划线  1111111100100100  double dot dash
    // ____ . . ____ . . ____ . . ____ . . ____
    FMKLINE_TRIDOTDASH,      ///三点划线  111111110101010 tri_dot_dash
    // ____ . . ____ . . ____ . . ____ . . ____
    FMKLINE_TEXTURE ,          //动态跨层线段
    FMKLINE_TEXTURE_MIX,
	FMKLINE_GRADIENT_TEXTURE_MIX
};

/**
 *  线段大小类型
 */
typedef NS_ENUM(NSInteger, FMKLineMode){
    /**
     *  像素宽度模式 不随放大缩小改变宽度
     */
    FMKLINE_PIXEL=0,
    /**
     *  空间宽度模式 随放大缩小变化宽度
     */
    FMKLINE_PLANE,
    /**
     *
     */
    FMKLINE_CIRCLE
};

@class FMKSegment;

/**
 * 地图线
 */
@interface FMKLineMarker : FMKNode

/**
 *  通过线段创建线，线段是由FMKNaviAnalyser分析结果数据生成的
 *
 *  @return 地图线对象
 */
- (instancetype)init;

/// 添加构造线所用的线段标注
- (void)addSegment:(FMKSegment *)segment;

/// 删除构造线所用的线段标注
- (void)removeSegment:(FMKSegment *)segment;

/**
 *  获取线的角度
 *
 *  @return 线角度集合
 */
- (NSArray *)getLineSegmentsAngles;

/**
 *  路径规划点集合
 *
 *  @return 点集合
 */
- (NSArray *)getLinePoints;

///路径线上线段
@property (readonly) NSArray*   segments;

//*****************************************************

///类型
@property (nonatomic,assign)        FMKLineType type;
///模式
@property (nonatomic,assign)        FMKLineMode mode;
///路线粗细,默认为2
@property (nonatomic,assign)        float       width;
///路线颜色，默认为蓝色
@property (nonatomic,copy)          UIColor*    color;
///是否隐藏
@property (nonatomic,assign)        BOOL        hidden;
///线标注物的图片
@property (nonatomic,copy)        NSString * imageName;

@property (nonatomic,assign)		BOOL mask;

@end








