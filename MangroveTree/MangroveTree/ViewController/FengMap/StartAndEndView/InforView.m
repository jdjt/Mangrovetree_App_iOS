//
//  inforView.m
//  MangroveTree
//
//  Created by liuchao on 2017/3/13.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "InforView.h"

@implementation InforView

+ (instancetype)inforView
{
    InforView * view = [[NSBundle mainBundle] loadNibNamed:@"InforView" owner:nil  options:nil][0];
    view.alpha = 0.0f;
    return view;
}
- (void)hide
{
    __weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.4f animations:^{
        wSelf.alpha = 0.0f;
    }];
}

- (void)show
{
    self.alpha = 0.9f;
    __weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.4f animations:^{
        CGRect rect = self.frame;
        wSelf.frame = CGRectMake(0, kScreenHeight-120-44 -88, kScreenWidth, rect.size.height);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
