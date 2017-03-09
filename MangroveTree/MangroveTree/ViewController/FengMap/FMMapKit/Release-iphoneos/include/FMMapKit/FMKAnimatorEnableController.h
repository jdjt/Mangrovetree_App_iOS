//
//  FMKAnimatorEnableController.h
//  FMMapKit
//
//  Created by FengMap on 15/11/13.
//  Copyright © 2015年 Fengmap. All rights reserved.
//
#import <Foundation/Foundation.h>


@class FMKSceneAnimator,FMKLayerAnimator,FMKGroupAnimator,FMKAnimator;
@class FMKMapView;

@interface FMKAnimatorEnableController : NSObject

/**
 *  设置动画开关
 */
@property(nonatomic,assign) BOOL isAnimator;

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
+(FMKAnimatorEnableController *)sharedFMKAnimatorEnableController;

@end
