//
//  ChatViewController+NetWork.h
//  MangroveTree
//
//  Created by liuchao on 2017/4/25.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController (NetWork)

- (void)cancelTaskAction:(UIBarButtonItem *)bar;
- (void)sengMsgToSerive;;
- (void)cancelDesicListWithTastStatus:(NSString *)type;
- (void)getTaskDetailByTaskCode:(NSString *)taskCode;

@end
