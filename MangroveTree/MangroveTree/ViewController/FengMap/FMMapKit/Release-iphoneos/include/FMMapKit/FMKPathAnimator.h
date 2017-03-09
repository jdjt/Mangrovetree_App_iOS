//
//  FMKPathAnimator.h
//  FMMapKit
//
//  Created by fengmap on 16/4/5.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMKAnimator.h"
@class FMKImageMarker;

@protocol FMKPathAnimatorDelegate;

@interface FMKPathAnimator : FMKAnimator

@property (nonatomic, weak)id<FMKPathAnimatorDelegate>pathDelegate;

@property (nonatomic, assign) double totalLength;

- (void)animatedWithTarget:(FMKImageMarker *)imageMarker;

/**
 *  路径动画参数
 *
 *  @param naviResult  地图坐标点集合
 *  @param angles      旋转角度集合
 *  @param repeatCount 重复次数
 */
- (void)animatedWithNaviResult:(NSArray*)naviResult
					withAngles:(NSArray *)angles
				   repeatCount:(int)repeatCount;

- (void)pause;
- (void)restart;

@end

@protocol FMKPathAnimatorDelegate <NSObject>

@optional
- (void)animatorIsExecuting:(FMKPathAnimator *)animator andNode:(FMKImageMarker *)imageMarker andNodePosition:(FMKMapPoint)position angle:(double)angle index:(NSInteger)index surplusLength:(double)surplusLength;

@end

