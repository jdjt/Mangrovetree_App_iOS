//
//  ChatViewController+NetWork.h
//  MangroveTree
//
//  Created by liuchao on 2017/4/25.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController (NetWork)

- (void)cancelTask:(NSString *)causeNum andTaskCode:(NSString *)taskCode;
- (void)sengMsgToSerive:(NSString *)message;
- (void)cancelDesicListWithTastStatus:(NSString *)type;
- (void)getTaskDetailByTaskCode:(NSString *)taskCode;
- (void)comfirmTask:(NSString *)comfirm andTaskCode:(NSString *)taskCode;
- (void)scoreTaskBy:(NSString *)taskCode andScoreType:(NSString *)type andScore:(NSString *)score;
- (void)getCustomDetailByCustomId:(NSString *)customId;

@end
