//
//  FMKNodeAssociation.h
//  FMMapKit
//
//  Created by fengmap on 16/8/29.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMKMap;
@class FMKExternalModel;
@class FMKLabel;

@interface FMKNodeAssociation : NSObject

/**
 初始化节点关联对象

 @param map 地图节点
 @param path json文件路径
 @return 节点关联对象
 */
- (instancetype)initWithMap:(FMKMap *)map path:(NSString *)path;

/**
 通过标签获取相应的模型

 @param label 标签
 @return 外部模型
 */
- (FMKExternalModel *)externalModelByLabel:(FMKLabel *)label;

/**
 设置模型的show状态

 @param externalModel 外部模型
 @param mask 是否show
 */
- (void)setMaskByExternalModel:(FMKExternalModel *)externalModel mask:(BOOL)mask;

/**
 设置外部模型的高亮状态

 @param externalModel 外部模型
 @param highlight 是否高亮
 */
- (void)setHighlightByExternalModel:(FMKExternalModel *)externalModel highlight:(BOOL)highlight;

/**
 设置标签和与标签关联的外部模型的show状态

 @param label 标签
 @param mask 是否Show
 */
- (void)setMaskByLabel:(FMKLabel *)label mask:(BOOL)mask;

/**
 设置标签和与标签关联的外部模型的高亮状态

 @param label 标签
 @param highlight 是否高亮
 */
- (void)setHighlightByLabel:(FMKLabel *)label highlight:(BOOL)highlight;

@end
