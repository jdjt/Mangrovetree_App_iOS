//
//  FMKNodeAnimator.h
//  FMMapKit
//
//  Created by fengmap on 16/3/31.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMKAnimator.h"

@class FMKNode;
@interface FMKNodeAnimator : FMKAnimator

/**
 *  设置节点动画参数
 *
 *  @param node    节点对象
 *  @param changeZ 改变量
 */
- (void)animatedWithTarget:(FMKNode *)node withChangeZ:(float)changeZ;

@end
