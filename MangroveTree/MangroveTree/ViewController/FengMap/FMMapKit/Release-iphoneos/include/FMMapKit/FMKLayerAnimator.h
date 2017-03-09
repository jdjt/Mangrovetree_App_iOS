//
//  FMKSceneAnimator.h
//  FMMapKit
//
//  Created by FengMap on 15/11/13.
//  Copyright © 2015年 Fengmap. All rights reserved.
//

#import "FMKAnimator.h"


@interface FMKLayerAnimator : FMKAnimator

/**
 *  <#Description#>
 *
 *  @param layerPointers <#layerPointers description#>
 */
- (void)zoomWithTarget:(NSArray *)layerPointers;

/**
 *  模型Z方向改变
 *
 *  @param fromZ 起始值
 *  @param toZ   终止值
 */
- (void)zoomFromScaleZ:(float)fromZ toZScale:(float)toZ;


@end
