//
//  inforView.h
//  MangroveTree
//
//  Created by liuchao on 2017/3/13.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HideViewBlock)(BOOL show);

@interface InforView : UIView

+ (instancetype)inforView;

@property (nonatomic, copy) HideViewBlock hideBlock;

- (void)show;
- (void)hide;
- (void)requsrtActivityInforByActivityCode:(NSString *)activityCode;

@end
