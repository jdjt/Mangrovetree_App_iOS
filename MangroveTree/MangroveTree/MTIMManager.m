//
//  MTIMManager.m
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/4/13.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "MTIMManager.h"

@interface MTIMManager () <YWMessageLifeDelegate>

@end

@implementation MTIMManager

- (id)init
{
    self = [super init];
    if (self) {
        // 初始化 链接状态
        [self setLastConnectionStatus:YWIMConnectionStatusDisconnected];
    }
    
    return self;
}

+ (instancetype)sharedInstance
{
    static MTIMManager * IMManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IMManager = [[MTIMManager alloc] init];
    });
    
    return IMManager;
}

- (void)callThisInDidFinishLaunching
{
    [self exampleSetCertName];
    
    if ([self exampleInit]) {
        // Push通知
        [self exampleHandleAPNSPush];
        
        /// 监听消息生命周期回调
        [self exampleListenMyMessageLife];
        
    }
    else
    {
        //  初始化失败
        [MyAlertView showAlert:@"呼叫管家组件初始化失败，如需使用呼叫管家请重新启动应用程序"];
    }
}

// 初始化
- (BOOL)exampleInit
{
    [[YWAPI sharedInstance] setEnvironment:YWEnvironmentRelease];
    /// 开启日志
    [[YWAPI sharedInstance] setLogEnabled:YES];
    NSError *error = nil;
    [[YWAPI sharedInstance] syncInitWithOwnAppKey:@"23337443" getError:&error];

    if (error.code != 0 && error.code != YWSdkInitErrorCodeAlreadyInited)
    {
        // 初始化失败
        return NO;
    }
    else
    {
        if (error.code == 0)
        {
            // 首次初始化成功
            self.IMCore = [[YWAPI sharedInstance] fetchNewIMCoreForOpenIM];
        }
        return YES;
    }
}

// 处理IM推送
- (void)exampleHandleAPNSPush
{
    __weak typeof(self) weakSelf = self;
    [[[YWAPI sharedInstance] getGlobalPushService] addHandlePushBlockV4:^(NSDictionary *aResult, BOOL *aShouldStop)
    {
        BOOL isLaunching = [aResult[YWPushHandleResultKeyIsLaunching] boolValue];
        UIApplicationState state = [aResult[YWPushHandleResultKeyApplicationState] integerValue];
        NSString *conversationId = aResult[YWPushHandleResultKeyConversationId];
        Class conversationClass = aResult[YWPushHandleResultKeyConversationClass];
        
        if (conversationId.length <= 0)
            return;
        
        if (conversationClass == NULL)
            return;
        
        if (isLaunching)
        {
            // 用户划开Push导致app启动 不需要处理
        }
        else
        {
            // app已经启动时处理Push
            // 应用在前台直接拉取新消息
            if (state == UIApplicationStateActive)
            {
                if (self.lastConnectionStatus != YWIMConnectionStatusConnected && self.lastConnectionStatus != YWIMConnectionStatusReconnected)
                {
                    YWConversation *conversation = nil;
                    if (conversationClass == [YWP2PConversation class])
                    {
                        conversation = [YWP2PConversation fetchConversationByConversationId:conversationId creatIfNotExist:YES baseContext:weakSelf.IMCore];
                        [self loadNewMessageByConversation:conversation];
                    }
                }
            }
            // 其他状态等待手动拉取消息 不做处理
            else{}
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

- (NSArray <YWMessageBody *> *)loadNewMessageByConversation:(YWConversation *)conversation
{
    __block NSArray * newMessage = nil;
    [conversation loadMoreMessages:conversation.conversationUnreadMessagesCount.integerValue completion:^(BOOL existMore) {
         newMessage = [conversation.fetchedObjects subarrayWithRange:NSMakeRange(0, conversation.conversationUnreadMessagesCount.integerValue)];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiGetNewMessage object:newMessage];
    return newMessage;
}

// 收取新消息
- (void)collectNewMessage
{
    __block NSMutableArray * messageArray = [NSMutableArray array];
    [[self.IMCore getConversationService] addOnNewMessageBlockV2:^(NSArray *aMessages, BOOL aIsOffline) {
        [aMessages enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {
            id<IYWMessage> message = [obj conformsToProtocol:@protocol(IYWMessage)] ? obj : nil;
            if (message)
                [messageArray addObject:message.messageBody];
        }];
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiGetNewMessage object:messageArray];
}

// 监听消息生命周期
- (void)exampleListenMyMessageLife
{
    [[self.IMCore getConversationService] addMessageLifeDelegate:self forPriority:YWBlockPriorityDeveloper];
}

- (void)messageLifeDidSend:(NSString *)aMessageId conversationId:(NSString *)aConversationId result:(NSError *)aResult
{
    // 消息发送完成后的处理
}

// 设置证书
- (void)exampleSetCertName
{
    // IM的消息推送证书
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.taobao.tcmpushtest"]) {
        [[[YWAPI sharedInstance] getGlobalPushService] setXPushCertName:@"sandbox"];
    } else {
        [[[YWAPI sharedInstance] getGlobalPushService] setXPushCertName:@"production"];
    }
}

// 登录
- (void)exampleLoginWithUserID:(NSString *)aUserID password:(NSString *)aPassword successBlock:(void(^)())aSuccessBlock failedBlock:(void(^)(NSError *aError))aFailedBlock
{
    [self collectNewMessage];
    aSuccessBlock = [aSuccessBlock copy];
    aFailedBlock = [aFailedBlock copy];
    
    /// 当IM向服务器发起登录请求之前，会调用这个block，来获取用户名和密码信息。
    [[self.IMCore getLoginService] setFetchLoginInfoBlock:^(YWFetchLoginInfoCompletionBlock aCompletionBlock) {
        aCompletionBlock(YES, aUserID, aPassword, nil, nil);
    }];
    
    /// 发起登录
    [[self.IMCore getLoginService] asyncLoginWithCompletionBlock:^(NSError *aError, NSDictionary *aResult) {
        if (aError.code == 0 || [[self.IMCore getLoginService] isCurrentLogined])
        {
            if (aSuccessBlock)
                aSuccessBlock();
        }
        else
        {
            if (aFailedBlock)
                aFailedBlock(aError);
        }
    }];
}

// 退出IM账号
- (void)exampleLogout
{
    [[self.IMCore getLoginService] asyncLogoutWithCompletionBlock:NULL];
}

// 发送消息
- (void)sendMessageBody:(YWMessageBody *)messageBody andWithPerson:(YWPerson *)person scheduleBlock:(void(^)(CGFloat progress, NSString * messageID))scheduleBlock failedBlock:(void(^)(NSError *))failedBlock
{
    scheduleBlock = [scheduleBlock copy];
    failedBlock = [failedBlock copy];
    // 获取会话
    YWP2PConversation * conversation = [YWP2PConversation fetchConversationByPerson:person creatIfNotExist:YES baseContext:self.IMCore];
    
    // 发送消息
    [conversation asyncSendMessageBody:messageBody controlParameters:nil progress:^(CGFloat progress, NSString * messageID)
    {
        // 消息进度信息
        if (scheduleBlock)
        {
            scheduleBlock(progress,messageID);
        }
    } completion:^(NSError *error, NSString *messageID)
    {
        // 消息发送失败
        if (error)
        {
            failedBlock(error);
        }
    }];
}

// 监听链接状态
- (void)exampleListenConnectionStatus
{
    __weak typeof(self) weakSelf = self;
    [[self.IMCore getLoginService] addConnectionStatusChangedBlock:^(YWIMConnectionStatus aStatus, NSError *aError) {
        
        [weakSelf setLastConnectionStatus:aStatus];
        
        if (aStatus == YWIMConnectionStatusForceLogout || aStatus == YWIMConnectionStatusMannualLogout || aStatus == YWIMConnectionStatusAutoConnectFailed) {
            // 手动登出、被踢、自动连接失败
            if (aStatus != YWIMConnectionStatusMannualLogout)
            {
                // 异常退出可能需要通知重新登录 待测试
            }
        }
        else if (aStatus == YWIMConnectionStatusConnected)
        {
            
        }
        else if (aStatus == YWIMConnectionStatusReconnected)
        {
            
        }
    } forKey:[self description] ofPriority:YWBlockPriorityDeveloper];
}

// 关闭指定会话
- (void)closeConversationBy:(YWConversation *)conversation
{
    [conversation stopConversation];
}

@end
