//
//  AlertPresentAnimation.h
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/4/12.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PresentOneTransitionType)
{
    PresentOneTransitionTypePresent = 0,//管理present动画
    PresentOneTransitionTypeDismiss = 1 //管理dismiss动画
};

@interface AlertPresentAnimation : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(PresentOneTransitionType)type;

@end
