//
//  FMKSceneAnimatorGroup.h
//  FMMapKit
//
//  Created by FengMap on 15/12/3.
//  Copyright © 2015年 Fengmap. All rights reserved.
//

#import "FMKAnimator.h"

typedef NS_ENUM(NSInteger,ANIMATE_ORDER)
{
    ORDER_SECQUENCE = 0,//正序
    ORDER_REVERSED,//逆序
};

@interface FMKSceneAnimatorGroup : FMKAnimator

///动画组顺序
@property(nonatomic,assign) ANIMATE_ORDER order;

+ (FMKSceneAnimatorGroup *)shareInstance;

- (void)animateInclineWithScale:(double)scale
               withInterpolator:(FMKInterpolator*)interpolator
               withDurationTime:(DurationTime)duration;

- (void)animateRotateWithScale:(double)scale
              withInterpolator:(FMKInterpolator *)interpolator
              withDurationTime:(DurationTime)duration;

- (void)animateZoomWithScale:(double)scale
            withInterpolator:(FMKInterpolator *)interpolator
            withDurationTime:(DurationTime)duration;

- (void)animateMoveWithStart:(CGPoint)start
                     withEnd:(CGPoint)end
            withInterpolator:(FMKInterpolator *)interpolator
            withDurationTime:(DurationTime)duration;

- (void)clearAnimationGroup;

- (void)startAnimator;

- (void)cancelAnimator; 

@end
