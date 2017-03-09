//
//  UIView+TransitionAnimation.h
//  mgmanager
//
//  Created by fengmap on 16/9/8.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TransitionAnimation)


- (void)show;
- (void)hide;
+ (void)showWithView:(UIView *)view;
+ (void)hideWithView:(UIView *)view;

@end
