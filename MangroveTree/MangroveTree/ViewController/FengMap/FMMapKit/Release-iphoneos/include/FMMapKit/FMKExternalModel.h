//
//  FMKExternalModel.h
//  FMMapKit
//
//  Created by fengmap on 16/6/1.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMKNode.h"

@interface FMKExternalModel : FMKNode

/**
 *  外部模型的唯一编码
 */
@property (nonatomic,readonly)NSString * fid;
/**
 *	外部模型名称
 */
@property (nonatomic,readonly)NSString * name;

/**
 *  外部模型英文名称
 */
@property (nonatomic,readonly)NSString * englishName;

/**
 *  外部模型所在楼层ID
 */
@property (nonatomic,readonly)NSString * groupID;
/**
 *  外部模型type
 */
@property (nonatomic,readonly)NSString * type;
/**
 *  外部模型的中心点地图坐标
 */
@property (nonatomic,readonly)FMKGeoCoord mapCoord;
/**
 *  外部模型的中心点  屏幕坐标
 */
@property (nonatomic,readonly)CGPoint centerPoint;

/**
 *  外部模型的隐藏属性
 */
@property (nonatomic,assign)BOOL hidden;

/**
 *  外部模型的选中属性
 */
@property (nonatomic,assign)BOOL selected;

/**
 *  外部模型的蒙版效果
 */
@property (nonatomic, assign)BOOL maskMode;

/**
 *  模型的高亮显示
 */
@property (nonatomic, assign) BOOL highlight;

@end
