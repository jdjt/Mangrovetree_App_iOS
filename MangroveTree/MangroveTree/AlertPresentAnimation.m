//
//  AlertPresentAnimation.m
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/4/12.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "AlertPresentAnimation.h"

@interface AlertPresentAnimation ()

@property (assign, nonatomic) PresentOneTransitionType type;

@end

@implementation AlertPresentAnimation

+ (instancetype)transitionWithTransitionType:(PresentOneTransitionType)type
{
    AlertPresentAnimation *animation = [[AlertPresentAnimation alloc] init];
    animation.type = type;
    return animation;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type)
    {
        case PresentOneTransitionTypePresent:
            [self prsentTransitionAnimate:transitionContext];
            break;
        case PresentOneTransitionTypeDismiss:
            [self dismissTransitionAnimate:transitionContext];
            break;
        default:
            break;
    }
}
- (void)prsentTransitionAnimate:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * viewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    viewController.view.alpha = 0;
    viewController.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:viewController.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{
                         viewController.view.alpha = 1;
                         viewController.view.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];

}
- (void)dismissTransitionAnimate:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * viewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    viewController.view.alpha = 1;
//    viewController.view.transform = CGAffineTransformMakeScale(1, 1);
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:viewController.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{
                         viewController.view.alpha = 0;
//                         viewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];

}

@end
