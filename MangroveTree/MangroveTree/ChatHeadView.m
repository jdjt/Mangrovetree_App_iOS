//
//  ChatHeadView.m
//  MangroveTree
//
//  Created by liuchao on 2017/4/13.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "ChatHeadView.h"
#import "PureLayout.h"

@interface ChatHeadView ()

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;

@end

@implementation ChatHeadView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addInforView];
    }
    return self;
}
- (void)addInforView
{
    self.label1 = [[UILabel alloc] init];
    _label1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label1];
    
    [self.label1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.label1 autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeHeight ofView:self withMultiplier:0.5];
    [self.label1 autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    self.label1.text = @"我就是一测试数据，我想看下实现教过如何，你不必当真";
    
    self.label2 = [[UILabel alloc] init];
    _label2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label2];
    [self.label2 autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    [self.label2 autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeHeight ofView:self withMultiplier:0.5];
    [self.label2 autoPinEdgeToSuperviewMargin:ALEdgeBottom];
    self.label2.text = @"我想效果还算不错，效果很好";
}

@end
