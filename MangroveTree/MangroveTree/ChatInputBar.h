//
//  ChatInputBar.h
//  MangroveTree
//
//  Created by liuchao on 2017/4/13.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatInputBar;

@protocol SendMsgDelegate <NSObject>

- (void)sendMsgByChatBarView:(ChatInputBar *)inputView;

@end

@interface ChatInputBar : UIView

@end
