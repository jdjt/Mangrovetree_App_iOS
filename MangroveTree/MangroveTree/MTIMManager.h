//
//  MTIMManager.h
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/4/13.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOUIModule/YWUIFMWK.h>

@interface MTIMManager : NSObject

@property (nonatomic, strong) YWIMCore * IMCore;
@property (nonatomic, assign) YWIMConnectionStatus lastConnectionStatus; // 链接状态

+ (instancetype)sharedInstance;

// 初始化
- (BOOL)exampleInit;

// 初始化入口 在appdelegate中调用
- (void)callThisInDidFinishLaunching;

// 设置证书
- (void)exampleSetCertName;

// 登录
- (void)exampleLoginWithUserID:(NSString *)aUserID password:(NSString *)aPassword successBlock:(void(^)())aSuccessBlock failedBlock:(void(^)(NSError *aError))aFailedBlock;

// 退出 (用户退出时同时退出IM账号)
- (void)exampleLogout;

// 发送消息
- (void)sendMessageBody:(YWMessageBody *)messageBody andWithPerson:(YWPerson *)person scheduleBlock:(void(^)(CGFloat progress, NSString * messageID))scheduleBlock failedBlock:(void(^)(NSError *))failedBlock;

// 获取新消息 会通过通知形式返回 也会返回对应的消息数组
- (NSArray <YWMessageBody *> *)loadNewMessageByConversation:(YWConversation *)conversation;

// 关闭会话
- (void)closeConversationBy:(YWConversation *)conversation;

@end
