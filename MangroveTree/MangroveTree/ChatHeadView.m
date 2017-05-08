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
@property (nonatomic, assign) NSInteger startTime;

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
    self.backgroundColor = [UIColor whiteColor];
    self.labelText = [[UILabel alloc] init];
    self.labelText.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.self.labelText];
    
    [self.labelText autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    [self.labelText autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeHeight ofView:self withMultiplier:0.4];
    [self.labelText autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    self.labelText.text = @"请您输入需要服务的内容，以便服务员接单";
    self.labelText.font = [UIFont systemFontOfSize:16.0f];
    self.labelText.textColor = [UIColor colorWithHexString:@"#484b59"];
    
    self.timerLabel = [[UILabel alloc] init];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timerLabel];
    [self.timerLabel autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    [self.timerLabel autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeHeight ofView:self withMultiplier:0.4];
    [self.timerLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.labelText withOffset:5];
    
    self.timerLabel.text = @"谢谢合作，祝您入住愉快！";
    self.timerLabel.font = [UIFont fontWithName:@"Courier New" size:17.0f];
    self.timerLabel.textColor = [UIColor colorWithHexString:@"#484b59"];
    

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
            self.labelText.textColor = [UIColor colorWithHexString:@"#484b59"];
            self.timerLabel.textColor = [UIColor colorWithHexString:@"#484b59"];
            break;
        case TextStatus_waiting:
            self.labelText.text = @"您的呼叫请求已发送，请等待接单";
            self.timerLabel.text = @"等待时长 00:00:00";
            self.timerLabel.textColor = [UIColor colorWithHexString:@"#ed8256"];
            self.labelText.textColor = [UIColor colorWithHexString:@"#484b59"];
            break;
        case TextStatus_proceed:
            self.labelText.text = [NSString stringWithFormat:@"服务员%@已接单，您可以语音聊天啦！",self.waiterId.length > 0 ? self.waiterId : @""];
            self.timerLabel.text = @"服务时长 00:00:00";
            self.timerLabel.textColor = [UIColor colorWithHexString:@"#ed8256"];
            self.labelText.textColor = [UIColor colorWithHexString:@"#484b59"];
            break;
        default:
            break;
    }

}
- (void)startTaskTimerByStartTime:(NSInteger)time
{
    self.startTime = time;
    NSInteger s = self.startTime % 60;
    NSInteger m;
    NSInteger h;
    if (self.startTime / 60 == 0)
    {
        m = 0;
        h = 0;
    }
    else
    {
        m = self.startTime / 60 % 60;
        h = self.startTime / 60 / 60;
    }
    NSString * timeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",h,m,s];
    self.timerLabel.text = [NSString stringWithFormat:@"%@%@",self.textStatus == TextStatus_waiting ? @"等待时长 " : @"服务时长 ",timeStr];
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myLog:) userInfo:nil repeats:YES];
    }
}
- (void)myLog:(NSTimer *)timer
{
    self.startTime += 1;
    NSInteger s = self.startTime % 60;
    NSInteger m;
    NSInteger h;
    if (self.startTime / 60 == 0)
    {
        m = 0;
        h = 0;
    }
    else
    {
        m = self.startTime / 60 % 60;
        h = self.startTime / 60 / 60;
    }
    NSString * time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",h,m,s];
    self.timerLabel.text = [NSString stringWithFormat:@"%@%@",self.textStatus == TextStatus_waiting ? @"等待时长 " : @"服务时长 ",time];
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
