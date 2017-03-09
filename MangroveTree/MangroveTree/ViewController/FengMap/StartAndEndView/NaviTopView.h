//
//  NaviTopView.h
//  FeiFanWandaDemo
//
//  Created by Haoyu Wang on 16/7/2.
//  Copyright © 2016年 fengmap. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StopNaiv)();

@interface NaviTopView : UIView

@property (nonatomic, copy)StopNaiv stopNaviBlock;

+ (instancetype)naviTopViewSetFrame:(CGRect)frame;

- (void)updateLength:(double)length;

@end
