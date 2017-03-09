//
//  FMKModelNode.h
//  FMMapKit
//
//  Created by FengMap on 15/5/22.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKNode.h"

/**
 * 地图模型节点，不支持创建
 */
@interface FMKModel : FMKNode

/**
 *  所在的groupID
 */
@property (readonly)     NSString*   groupID;
/**
 *  中文名
 */
@property (readonly)     NSString*   title;
/**
 *  英文名
 */
@property (readonly)     NSString*   englishTitle;
/**
 *  fid
 */
@property (readonly)     NSString*   fid;
/**
 *  type
 */
@property (readonly)     NSString*   type;
/**
 *  模型屏幕坐标中心点
 */
@property (readonly)     CGPoint     centerPoint;

//******************************************************
/**
 *  元素的隐藏属性
 */
@property (nonatomic,assign)  BOOL hidden;
/**
 *  颜色设置
 */
@property (nonatomic,copy)      UIColor*    color;
/**
 *  边线颜色
 */
@property (nonatomic,copy)      UIColor*    lineColor;
/**
 *  选中状态
 */
@property (nonatomic,assign)    BOOL        selected;
/**
 *  边线宽度
 */
@property (nonatomic,assign)    float       lineWidth;

/**
 *  模型的地图中心点
 */
@property (nonatomic,readonly) FMKGeoCoord coord;

/**
 *  模型高度
 */
@property (nonatomic,readonly)float height;

@end
