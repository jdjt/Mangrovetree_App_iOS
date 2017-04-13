//
//  AlertPresentAnimation.m
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/4/12.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "AlertPresentAnimation.h"

@implementation AlertPresentAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    BaseAlertViewController * alert = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    alert.view.alpha = 0;
    alert.backGroundView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:alert.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{
                         alert.view.alpha = 1;
                         alert.backGroundView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end
