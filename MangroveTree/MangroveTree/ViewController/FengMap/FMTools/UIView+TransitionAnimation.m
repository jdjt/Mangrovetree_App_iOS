//
//  UIView+TransitionAnimation.m
//  mgmanager
//
//  Created by fengmap on 16/9/8.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "UIView+TransitionAnimation.h"
#import "Const.h"
@implementation UIView (TransitionAnimation)

- (void)show
{
	[UIView animateWithDuration:0.6f animations:^{
		self.alpha = 1.0f;
        self.hidden = NO;
	}];
}

- (void)hide
{
	[UIView animateWithDuration:0.6f animations:^{
		self.alpha = 0.0f;
        self.hidden = YES;
	}];
}

+ (void)showWithView:(UIView *)view
{
	[UIView animateWithDuration:0.3 animations:^{
		view.frame = CGRectMake(0, kNaviHeight, kScreenWidth, kScreenHeight-kNaviHeight);
	}];
}

+ (void)hideWithView:(UIView *)view
{
	[UIView animateWithDuration:0.3 animations:^{
		view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-kNaviHeight);
	}];
}

@end
