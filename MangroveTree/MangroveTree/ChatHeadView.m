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

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *startTime;

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
    self.labelText = [[UILabel alloc] init];
    self.labelText.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.self.labelText];
    
    [self.labelText autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.labelText autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeHeight ofView:self withMultiplier:0.5];
    [self.labelText autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    self.labelText.text = @"请您输入需要服务的内容，以便服务员接单";
    self.labelText.font = [UIFont systemFontOfSize:16.0f];
    
    self.timerLabel = [[UILabel alloc] init];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timerLabel];
    [self.timerLabel autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    [self.timerLabel autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeHeight ofView:self withMultiplier:0.5];
    [self.timerLabel autoPinEdgeToSuperviewMargin:ALEdgeBottom];
    self.timerLabel.text = @"谢谢合作，祝您入住愉快！";
    self.labelText.font = [UIFont systemFontOfSize:16.0f];

}

- (void)setTextStatus:(TextStatus)textStatus
{
    if (_textStatus != textStatus)
    {
        _textStatus = textStatus;
        [self changeTextContentByTextStatus:_textStatus];
     }
}
- (void)changeTextContentByTextStatus:(TextStatus)status
{
    switch (status)
    {
        case TextStatus_default:
            self.labelText.text = @"请您输入需要服务的内容，以便服务员接单";
            self.timerLabel.text = @"谢谢合作，祝您入住愉快！";
            break;
        case TextStatus_waiting:
            self.labelText.text = @"您的服务订单请求已发送，请等待接单后再发送更多内容";
            self.timerLabel.text = @"等候时长:00:00:01";
            [self startTaskTimerByStartTime:nil];
            break;
        case TextStatus_proceed:
            self.labelText.text = @"服务员T001已接单，您可以语音聊天啦！";
            self.timerLabel.text = @"服务时长:00:00:01";
            [self startTaskTimerByStartTime:nil];
            break;
        default:
            break;
    }

}
- (void)startTaskTimerByStartTime:(NSString *)time
{
    self.startTime = time;
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myLog:) userInfo:nil repeats:YES];
    }
}
- (void)myLog:(NSTimer *)timer
{
    
}
- (void)stopTimer
{
    if (self.timer && self.timer.isValid)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)dealloc
{
    [self stopTimer];
}
@end
