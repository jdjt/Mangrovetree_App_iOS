//
//  FMKSceneAnimator.h
//  FMMapKit
//
//  Created by FengMap on 15/11/4.
//  Copyright © 2015年 FengMap. All rights reserved.
//

#import "FMKAnimator.h"


@interface FMKSceneAnimator: FMKAnimator

/**
 *  场景移动动画
 *
 *  @param start 起始位置
 *  @param end   终点位置
 */
- (void)moveWithStart:(CGPoint )start
              withEnd:(CGPoint )end;

/**
 *  场景旋转动画
 *
 *  @param angle 旋转值，单位为角度
 */
- (void)rotateWithAngle:(float)angle;

/**
 *  场景缩放动画
 *
 *  @param scale 缩放比例
 */
- (void)zoomWithScale:(float)scale;

/**
 *  场景倾斜动画
 *
 *  @param angle 场景倾斜值，单位为角度
 */
- (void)inclineWithAngle:(float)angle;

/**
 *  场景惯性动画
 *
 *  @param VelocityX x轴速度
 *  @param VelocityY Y轴速度
 *  @param startTime 起始时间
 *  @param endTime   终止时间
 */
- (void)flyingWithVelocityX:(float)velocityX VelocityY:(float)velocityY startTime:(NSDate*)startTime endTime:(NSDate *)endTime;

//移动到屏幕中央动画 mapPoint
- (void)moveToViewCenterAnimationFromMapPoint:(FMKMapPoint)mapPoint;

@end
