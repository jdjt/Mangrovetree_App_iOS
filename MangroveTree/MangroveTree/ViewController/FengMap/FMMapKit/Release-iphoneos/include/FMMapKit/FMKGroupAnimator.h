//
//  FMKGroupAnimator.h
//  FMMapKit
//
//  Created by fengmap on 16/2/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMKAnimator.h"

@interface FMKGroupAnimator : FMKAnimator

- (void)springWithTargets:(NSArray *)nodes;

- (void)springFromStartX:(CGFloat)startX toEndX:(CGFloat)endX startY:(CGFloat)startY toY:(CGFloat)endY startZ:(CGFloat)startZ toZ:(CGFloat)endZ  startAlpha:(float)startAlpha withEndAlpha:(float)alpha;

- (void)springWithChangeX:(CGFloat)changedX
             withChangedY:(CGFloat)changedY
             withChangedZ:(CGFloat)changedZ
             withEndAlpha:(CGFloat)endAlpha;

@end
