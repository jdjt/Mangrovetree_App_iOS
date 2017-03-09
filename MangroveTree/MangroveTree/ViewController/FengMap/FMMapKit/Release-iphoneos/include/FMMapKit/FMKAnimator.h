//
//  FMKAnimator.h
//  FMMapKit
//
//  Created by FengMap on 15/11/4.
//  Copyright © 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMKMapView;

#import "FMKInterpolator.h"
#import "FMKLinearInterpolator.h"
#import "FMKCubicInterpolator.h"
#import "FMKSineInterpolator.h"


/**
 *  动画持续时间
 */
typedef double DurationTime;

/**
 *  动画类型
 */
typedef NS_OPTIONS(NSInteger, ANIMATE_TYPE)
{
	ANIMATE_NONE     =  0,
	ANIMATE_MOVE     =  0x01<<0,  //移动
	ANIMATE_ROTATE   =  0x01<<1,  //旋转
	ANIMATE_ZOOM     =  0x01<<2,  //缩放
	ANIMATE_INCLINE  =  0x01<<3,  //场景倾斜
	ANIMATE_FLYING   =  0x01<<4,  //场景移动动画效果
	ANIMATE_SPRING   =  0x01<<5,  //节点的动画效果
	ANIMATE_TO_CENTER = 0x01<<5
};
/**
 *  动画状态
 */
typedef NS_ENUM(NSInteger,ANIMATE_STATUS) {
	
	ANIMATE_WILL_START = 1,

	ANIMATE_IS_EXECUTING,
	
	ANIMATE_FINISH
};

@protocol  FMKAnimatorDelegate;

@interface FMKAnimator : NSObject

@property(nonatomic,strong)FMKMapView * mapView;

/**
 *  当前动画类型
 */
@property(nonatomic,assign) ANIMATE_TYPE currentState;

/**
 *  插值器 
 */
@property(nonatomic,strong) FMKInterpolator * interpolator;

/**
 *  动画持续时间
 */
@property(nonatomic,assign) DurationTime durationTime;

@property (nonatomic, weak) id<FMKAnimatorDelegate>delegate;
@property (nonatomic,assign) ANIMATE_STATUS animate_status;

/**
 *  初始化方法
 *
 *  @param mapView 地图显示View
 *
 *  @return 返回对象
 */
- (id)initWithMapView:(FMKMapView *)mapView withDurationTime:(DurationTime)durationTime;

/**
 *  惯性动画
 *
 *  @param startPoint 起始位置
 *  @param endPoint   终点位置
 *  @param startTime  起始时间
 *  @param endTime    终止时间
 */
- (void)flyingWithStartPoint:(CGPoint)startPoint
                withEndPoint:(CGPoint)endPoint
               withStartTime:(NSDate*)startTime
                 withEndTime:(NSDate*)endTime;

/**
 *  惯性动画
 *
 *  @param startPoint   起始位置
 *  @param endPoint     终点位置
 *  @param timeInterval 时间差
 */
- (void)flyingWithStartPoint:(CGPoint)startPoint
                withEndPoint:(CGPoint)endPoint
            withTimeInterval:(NSTimeInterval)timeInterval;




/**
 *  动画开始
 */
- (void)startAnimation;

/**
 *  动画结束
 */
- (void)cancelAnimation;

@end

@protocol FMKAnimatorDelegate <NSObject>

@optional
- (void)animatorWillStart:(FMKAnimator *)animator;
- (void)animatorIsExecuting:(FMKAnimator *)animator;
- (void)animatorFinish:(FMKAnimator *)animator;
@end

