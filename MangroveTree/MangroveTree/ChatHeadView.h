//
//  ChatHeadView.h
//  MangroveTree
//
//  Created by liuchao on 2017/4/13.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TextStatus)
{
    TextStatus_default = 1,
    TextStatus_waiting = 2,
    TextStatus_proceed = 3,
};

@interface ChatHeadView : UIView

@property (nonatomic, assign) TextStatus textStatus;
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UILabel *timerLabel;

@property (nonatomic, copy) NSString * waiterId;

- (void)startTaskTimerByStartTime:(NSString *)time;
- (void)stopTimer;

@end
