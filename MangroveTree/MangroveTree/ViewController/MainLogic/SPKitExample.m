//
//  SPKitExample.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPKitExample.h"

#import <AVFoundation/AVFoundation.h>

#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOUIModule/YWUIFMWK.h>

#import "SPBaseBubbleChatViewCustomize.h"
#import "SPBubbleViewModelCustomize.h"

#import "SPInputViewPluginGreeting.h"
#import "SPInputViewPluginCallingCard.h"
#import "SPInputViewPluginTransparent.h"

#import <WXOUIModule/YWIndicator.h>
#import <objc/runtime.h>
#import <WXOpenIMSDKFMWK/YWTribeSystemConversation.h>
#import <WXOpenIMSDKFMWK/YWMessageBodyCustomizeInternal.h>
#import <WXOpenIMSDKFMWK/YWCombinedForwardConversation.h>

#if __has_include("YWFeedbackServiceFMWK/YWFeedbackServiceFMWK.h")
#import <YWFeedbackServiceFMWK/YWFeedbackServiceFMWK.h>
#define HAS_FEEDBACK 1
#endif

#if __has_include("SPMessageInputView.h")
#import "SPMessageInputView.h"
#define HAS_CUSTOMINPUT 1
#endif

#if __has_include("SPContactListController.h")
#import "SPContactListController.h"
#define HAS_CONTACTLIST 1
#endif

#import "SPGreetingBubbleViewModel.h"
#import "SPGreetingBubbleChatView.h"

#if __has_include(<YWExtensionForShortVideoFMWK/IYWExtensionForShortVideoService.h>)
#import <YWExtensionForShortVideoFMWK/IYWExtensionForShortVideoService.h>

#define SPExtensionServiceFromProtocol(service) \
(id<service>)[[[YWAPI sharedInstance] getGlobalExtensionService] getExtensionByServiceName:NSStringFromProtocol(@protocol(service))]
#endif

@interface SPKitExample ()
<YWMessageLifeDelegate,
UIAlertViewDelegate>

#define kSPAlertViewTagPhoneCall 2046

@end

@implementation SPKitExample

#pragma mark - life

- (id)init
{
    self = [super init];
    
    if (self) {
        /// 初始化
        [self setLastConnectionStatus:YWIMConnectionStatusDisconnected];
    }
    
    return self;
}


#pragma mark - properties

- (id<UIApplicationDelegate>)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

- (UIWindow *)rootWindow
{
    UIWindow *result = nil;
    
    do {
        if ([self.appDelegate respondsToSelector:@selector(window)]) {
            result = [self.appDelegate window];
        }
        
        if (result) {
            break;
        }
    } while (NO);
    
    
    NSAssert(result, @"如果在您的App中出现这个断言失败，请参考：【https://bbs.aliyun.com/read.php?spm=0.0.0.0.ia5H4C&tid=263177&displayMode=1&page=1&toread=1#tpc】");
    
    return result;
    
}

- (UINavigationController *)conversationNavigationController {
    UITabBarController *tabBarController = (UITabBarController *)self.rootWindow.rootViewController;
    if (![tabBarController isKindOfClass:[UITabBarController class]]) {
        return nil;
    }

    UINavigationController *navigationController = tabBarController.viewControllers.firstObject;
    if (![navigationController isKindOfClass:[UINavigationController class]]) {
        navigationController = nil;
        NSAssert(navigationController, @"如果在您的 App 中出现这个断言失败，请参考：【https://bbs.aliyun.com/read.php?spm=0.0.0.0.ia5H4C&tid=263177&displayMode=1&page=1&toread=1#tpc】");
    }

    return navigationController;
}


#pragma mark - private methods


#pragma mark - public methods

+ (instancetype)sharedInstance
{
    static SPKitExample *sExample = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sExample = [[SPKitExample alloc] init];
    });
    
    return sExample;
}

#pragma mark - SDK Life Control
/**
 *  程序完成启动，在appdelegate中的 application:didFinishLaunchingWithOptions:一开始的地方调用
 */
- (void)callThisInDidFinishLaunching
{
    [self exampleSetCertName];
    
    if ([self exampleInit]) {
        // 在IMSDK截获到Push通知并需要您处理Push时，IMSDK会自动调用此回调
        [self exampleHandleAPNSPush];

        // 自定义头像样式
        [self exampleSetAvatarStyle];

        /// 监听消息生命周期回调
        [self exampleListenMyMessageLife];
        
    } else {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"SDK初始化失败, 请检查网络后重试" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:alertAction];
            
            [[self conversationNavigationController] presentViewController:alertController animated:YES completion:nil];
        } else {
            /// 初始化失败，需要提示用户
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK初始化失败, 请检查网络后重试"
                                                        delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil];
            [av show];
        }
    }
}

/**
 *  用户在应用的服务器登录成功之后，向云旺服务器登录之前调用
 *  @param ywLoginId 用来登录云旺IMSDK的id
 *  @param passWord 用来登录云旺IMSDK的密码
 *  @param aSuccessBlock 登陆成功的回调
 *  @param aFailedBlock 登录失败的回调
 */
- (void)callThisAfterISVAccountLoginSuccessWithYWLoginId:(NSString *)ywLoginId passWord:(NSString *)passWord preloginedBlock:(void(^)())aPreloginedBlock successBlock:(void(^)())aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock
{
    /// 监听连接状态
    [self exampleListenConnectionStatus];
    
    /// 设置声音播放模式
    [self exampleSetAudioCategory];
    
    /// 监听新消息
    [self exampleListenNewMessage];
    
    /// 监听链接点击事件
    [self exampleListenOnClickUrl];
    
    /// 监听预览大图事件
    [self exampleListenOnPreviewImage];
    
    /// 开启单聊已读未读状态显示
    [self exampleEnableReadFlag];
    
    if ([ywLoginId length] > 0 && [passWord length] > 0) {
        /// 预登陆
        [self examplePreLoginWithLoginId:ywLoginId successBlock:aPreloginedBlock];
        
        /// 真正登录
        [self exampleLoginWithUserID:ywLoginId password:passWord successBlock:aSuccessBlock failedBlock:aFailedBlock];
    } else {
        if (aFailedBlock) {
            aFailedBlock([NSError errorWithDomain:YWLoginServiceDomain code:YWLoginErrorCodePasswordError userInfo:nil]);
        }
    }
}

/**
 *  用户即将退出登录时调用
 */
- (void)callThisBeforeISVAccountLogout
{
    [self exampleLogout];
}

#pragma mark - basic

- (NSNumber *)lastEnvironment
{
    NSNumber *environment = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastEnvironment"];
    if (environment == nil) {
        return @(YWEnvironmentRelease);
    }
    return environment;
}

/**
 *  设置证书名的示例代码
 */
- (void)exampleSetCertName
{
    /// 你可以根据当前的bundleId，设置不同的证书，避免修改代码
    
    /// 这些证书是我们在百川后台添加的。
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.taobao.tcmpushtest"]) {
        [[[YWAPI sharedInstance] getGlobalPushService] setXPushCertName:@"sandbox"];
    } else {
        /// 默认的情况下，我们都设置为生产证书
        [[[YWAPI sharedInstance] getGlobalPushService] setXPushCertName:@"production"];
    }
    
}

/**
 *  初始化示例代码
 */
- (BOOL)exampleInit;
{
    
    //[[YWAPI sharedInstance] setLogEnabled:YES];

    NSError *error = nil;
    
    /// 异步初始化IM SDK
    // 设置环境，开发者可以不设置。默认是 线上环境 YWEnvironmentRelease
    [[YWAPI sharedInstance] setEnvironment:[self lastEnvironment].intValue];
//    [[YWAPI sharedInstance] setEnvironment:YWEnvironmentRelease];
    
    if ([self lastEnvironment].intValue == YWEnvironmentRelease || [self lastEnvironment].intValue == YWEnvironmentPreRelease) {
//#warning TODO: CHANGE TO YOUR AppKey
        /// 线上环境，更换成你自己的AppKey
        [[YWAPI sharedInstance] syncInitWithOwnAppKey:@"23758144" getError:&error];
    } else {
        // OpenIM内网环境，暂时不向开发者开放，需要测试环境的，自行申请另一个Appkey作为测试环境
//        [[YWAPI sharedInstance] syncInitWithOwnAppKey:@"4272" getError:&error];
        [[YWAPI sharedInstance] syncInitWithOwnAppKey:@"23758144" getError:&error];
    }

    if (error.code != 0 && error.code != YWSdkInitErrorCodeAlreadyInited) {
        /// 初始化失败
        return NO;
    } else {
        if (error.code == 0) {
            /// 首次初始化成功
            /// 获取一个IMKit并持有
            self.ywIMKit = [[YWAPI sharedInstance] fetchIMKitForOpenIM];
            [[self.ywIMKit.IMCore getContactService] setEnableContactOnlineStatus:YES];
        } else {
            /// 已经初始化
        }
        return YES;
    }
}

/**
 *  登录的示例代码
 */
- (void)exampleLoginWithUserID:(NSString *)aUserID password:(NSString *)aPassword successBlock:(void(^)())aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock
{
    aSuccessBlock = [aSuccessBlock copy];
    aFailedBlock = [aFailedBlock copy];
    
    // 登录之前，先告诉IM如何获取登录信息。
    // 当IM向服务器发起登录请求之前，会调用这个block，来获取用户名和密码信息。
    [[self.ywIMKit.IMCore getLoginService] setFetchLoginInfoBlock:^(YWFetchLoginInfoCompletionBlock aCompletionBlock) {
        aCompletionBlock(YES, aUserID, aPassword, nil, nil);
    }];
    
    // 发起登录
    [[self.ywIMKit.IMCore getLoginService] asyncLoginWithCompletionBlock:^(NSError *aError, NSDictionary *aResult) {
        if (aError.code == 0 || [[self.ywIMKit.IMCore getLoginService] isCurrentLogined]) {
            // 登录成功
        } else {
            // 登录失败
            if (aFailedBlock) {
                aFailedBlock(aError);
            }
        }
    }];
}

/**
 *  预登陆
 */
- (void)examplePreLoginWithLoginId:(NSString *)loginId successBlock:(void(^)())aPreloginedBlock
{
    /// 预登录
    if ([[self.ywIMKit.IMCore getLoginService] preLoginWithPerson:[[YWPerson alloc] initWithPersonId:loginId]]) {
        /// 预登录成功，直接进入页面,这里可以打开界面
        if (aPreloginedBlock) {
            aPreloginedBlock();
        }
    }
}

/**
 *  监听连接状态
 */
- (void)exampleListenConnectionStatus
{
    __weak typeof(self) weakSelf = self;
    [[self.ywIMKit.IMCore getLoginService] addConnectionStatusChangedBlock:^(YWIMConnectionStatus aStatus, NSError *aError) {
        
        [weakSelf setLastConnectionStatus:aStatus];

        if (aStatus == YWIMConnectionStatusForceLogout || aStatus == YWIMConnectionStatusMannualLogout || aStatus == YWIMConnectionStatusAutoConnectFailed) {
            /// 手动登出、被踢、自动连接失败，都退出到登录页面
            if (aStatus != YWIMConnectionStatusMannualLogout) {
        
            }

        }
    } forKey:[self description] ofPriority:YWBlockPriorityDeveloper];
}


/**
 *  注销的示例代码
 */
- (void)exampleLogout
{
    [[self.ywIMKit.IMCore getLoginService] asyncLogoutWithCompletionBlock:NULL];
}

#pragma mark - abilities


/**
 *  设置声音播放模式
 */
- (void)exampleSetAudioCategory
{
    /// 设置为扬声器模式，这样可以支持靠近耳朵时自动切换到听筒
    [self.ywIMKit setAudioSessionCategory:AVAudioSessionCategoryPlayback];
}


- (void)exampleSetAvatarStyle
{
    [self.ywIMKit setAvatarImageViewCornerRadius:4.f];
    [self.ywIMKit setAvatarImageViewContentMode:UIViewContentModeScaleAspectFill];
}

#pragma mark - ui pages

/**
 *  打开某个会话
 */
- (void)exampleOpenConversationViewControllerWithConversation:(YWConversation *)aConversation fromNavigationController:(UINavigationController *)aNavigationController
{

    UINavigationController *conversationNavigationController = nil;
//    if (aNavigationController) {
        conversationNavigationController = aNavigationController;
//    }
//    else {
//        conversationNavigationController = [self conversationNavigationController];
//    }

    __block YWConversationViewController *conversationViewController = nil;
    [aNavigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[YWConversationViewController class]]) {
            YWConversationViewController *c = obj;
            if (aConversation.conversationId && [c.conversation.conversationId isEqualToString:aConversation.conversationId]) {
                conversationViewController = c;
                *stop = YES;
            }
        }
    }];

    if (!conversationViewController) {
        /// 如果是这两种基础conversation，重新fetch一个新的，防止原对象中还有一些状态未结束。
        if ([aConversation isKindOfClass:[YWP2PConversation class]]) {
            aConversation = [YWP2PConversation fetchConversationByPerson:[(YWP2PConversation *)aConversation person] creatIfNotExist:YES baseContext:self.ywIMKit.IMCore];
            /// 如果需要，可以在这里设置其他一些需要修改的属性
        } else if ([aConversation isKindOfClass:[YWTribeConversation class]]) {
            aConversation = [YWTribeConversation fetchConversationByTribe:[(YWTribeConversation *)aConversation tribe] createIfNotExist:YES baseContext:self.ywIMKit.IMCore];
        }
        conversationViewController = [self exampleMakeConversationViewControllerWithConversation:aConversation];
    }

    NSArray *viewControllers = nil;
    if (conversationNavigationController.viewControllers.firstObject == conversationViewController) {
        viewControllers = @[conversationNavigationController.viewControllers.firstObject];
    }
    else {
        NSLog(@"conversationNavigationController.viewControllers.firstObject:%@", conversationNavigationController.viewControllers.firstObject);
        NSLog(@"conversationViewController:%@", conversationViewController);
        viewControllers = @[conversationNavigationController.viewControllers.firstObject, conversationViewController];
    }

    [conversationNavigationController setViewControllers:viewControllers animated:YES];
}

/**
 *  打开单聊页面
 */
- (void)exampleOpenConversationViewControllerWithPerson:(YWPerson *)aPerson fromNavigationController:(UINavigationController *)aNavigationController
{
    YWConversation *conversation = [YWP2PConversation fetchConversationByPerson:aPerson creatIfNotExist:YES baseContext:self.ywIMKit.IMCore];
    
    [self exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:aNavigationController];
}

- (void)exampleOpenEServiceConversationWithPersonId:(NSString *)aPersonId fromNavigationController:(UINavigationController *)aNavigationController
{
    YWPerson *person = [[SPKitExample sharedInstance] exampleFetchEServicePersonWithPersonId:aPersonId groupId:nil];
    [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:aNavigationController];
}

/**
 *  创建某个会话Controller，在这个Demo中仅用于iPad SplitController中显示会话
 */
- (YWConversationViewController *)exampleMakeConversationViewControllerWithConversation:(YWConversation *)conversation {
    YWConversationViewController *conversationController = nil;
#if HAS_TRIBECONVERSATION
    /// Demo中使用了继承方式，实现群聊聊天页面。
    if ([conversation isKindOfClass:[YWTribeConversation class]]) {
        conversationController = [SPTribeConversationViewController makeControllerWithIMKit:self.ywIMKit
                                                                               conversation:conversation];
        
        [self.ywIMKit addDefaultInputViewPluginsToMessagesListController:conversationController];
        
    }
    else
#endif
#if HAS_FEEDBACK
        #warning 如果集成使用反馈服务，点击会话列表需要拦截反馈会话并反馈会话
        if ([conversation isKindOfClass:[YWFeedbackConversation class]]) {
            YWFeedbackConversation *feedbackConversation = (YWFeedbackConversation *)conversation;
            conversationController = [self.ywIMKit makeFeedbackViewControllerWithConversation:feedbackConversation];

            [conversationController setHidesBottomBarWhenPushed:YES];

            conversationController.hidesBottomBarWhenPushed = YES;
            return conversationController;
        }
        else
#endif
    {
        conversationController = [YWConversationViewController makeControllerWithIMKit:self.ywIMKit conversation:conversation];
        [self.ywIMKit addDefaultInputViewPluginsToMessagesListController:conversationController];
    }
    
    if ([conversation isKindOfClass:[YWP2PConversation class]] && [((YWP2PConversation *)conversation).person.personId isEqualToString:@"云大旺"]) {
        conversationController.disableTitleAutoConfig = YES;
        conversationController.title = @"自定义标题";
        conversationController.disableTextShowInFullScreen = YES;
    }

    /// 添加自定义插件
    [self exampleAddInputViewPluginToConversationController:conversationController];

    /// 添加自定义表情
    [self exampleShowCustomEmotionWithConversationController:conversationController];

    /// 设置消息长按菜单
    [self exampleSetMessageMenuToConversationController:conversationController];

    conversationController.hidesBottomBarWhenPushed = YES;

    return conversationController;
}

#pragma mark - Customize

- (void)exampleEnableTribeAtMessage
{
    [self.ywIMKit.IMCore getSettingService].disableAtFeatures = NO;
}

- (void)exampleEnableReadFlag
{
    // 开启单聊已读未读显示开关，如果应用场景不需要，可以关闭
    [[self.ywIMKit.IMCore getConversationService] setEnableMessageReadFlag:NO];
}

#pragma mark - 聊天页面自定义

/**
 *  添加输入面板插件
 */
- (void)exampleAddInputViewPluginToConversationController:(YWConversationViewController *)aConversationController
{
    // 添加插件
    if ([aConversationController.messageInputView isKindOfClass:[YWMessageInputView class]]) {
        
        if ([aConversationController.conversation isKindOfClass:[YWP2PConversation class]]) {
            /// 此功能仅作为示例代码
            /**
            SPInputViewPluginTransparent *pluginTransparent = [[SPInputViewPluginTransparent alloc] init];
            [messageInputView addPlugin:pluginTransparent];
             */
        }
        
    }
}

/**
 *  插入本地消息
 *  消息不会被发送到对方，仅本地展示
 */
- (void)exampleInsertLocalMessageBody:(YWMessageBody *)aBody inConversation:(YWConversation *)aConversation
{
    NSDictionary *controlParameters = @{kYWMsgCtrlKeyClientLocal:@{kYWMsgCtrlKeyClientLocalKeyOnlySave:@(YES)}}; /// 控制字段
    [aConversation asyncSendMessageBody:aBody controlParameters:controlParameters progress:NULL completion:NULL];
}


/**
 *  设置如何显示自定义表情
 */
- (void)exampleShowCustomEmotionWithConversationController:(YWConversationViewController *)aConversationController
{
    if ([aConversationController.messageInputView isKindOfClass:[YWMessageInputView class]]) {
        YWMessageInputView *messageInputView = (YWMessageInputView *)aConversationController.messageInputView;
        for ( id item in messageInputView.allPluginList )
        {
            if ( ![item isKindOfClass:[YWInputViewPluginEmoticonPicker class]] ) continue;

            YWInputViewPluginEmoticonPicker *emotionPicker = (YWInputViewPluginEmoticonPicker *)item;

            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"YW_TGZ_Emoitons" ofType:@"emo"];
            NSArray *groups = [YWEmoticonGroupLoader emoticonGroupsWithEMOFilePath:filePath];

            for (YWEmoticonGroup *group in groups)
            {
                [emotionPicker addEmoticonGroup:group];
            }
        }

    }
}

/**
 *  设置气泡最大宽度
 */
- (void)exampleSetMaxBubbleWidth
{
    [YWBaseBubbleChatView setMaxWidthUsedForLayout:280.f];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString* strError = @"保存成功，照片已经保存至相册。";
    if( error != nil )
    {
        strError = error.localizedDescription;
    }
}

/**
 *  设置编辑模式的菜单项
 */
- (void)exampleSetMenuForEditModeToConversationController:(YWConversationViewController *)aConversationController
{
    __weak typeof(aConversationController) weakController = aConversationController;
    
    [aConversationController setEditModeActionsBlock:^NSArray<YWMoreActionItem *> *(YWConversationViewController *aFromController) {
        YWConversationViewController *strongController = weakController;
        if (strongController == nil) { return nil; }

        NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:10];
        
        [result addObject:[weakController fetchEditModeItemForDelete]];
        return result;
    }];
}

/**
 *  设置消息的长按菜单
 */
- (void)exampleSetMessageMenuToConversationController:(YWConversationViewController *)aConversationController
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(aConversationController) weakController = aConversationController;
    [aConversationController setMessageCustomMenuItemsBlockV2:^NSArray *(id<IYWMessage> aMessage, NSArray *defaultItems) {
        YWConversationViewController *strongController = weakController;
        if (strongController == nil) { return nil; }
        
        NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:5];
        if (defaultItems.count > 0) { [result addObjectsFromArray:defaultItems]; }
        
        if ([[aMessage messageBody] isKindOfClass:[YWMessageBodyImage class]]) {
            YWMessageBodyImage *bodyImage = (YWMessageBodyImage *)[aMessage messageBody];
            if (bodyImage.originalImageType == YWMessageBodyImageTypeNormal) {
                /// 对于普通图片，我们增加一个保存按钮
                YWMoreActionItem *item = [[YWMoreActionItem alloc] initWithActionName:@"保存" actionBlock:^(NSDictionary *aUserInfo) {
                    NSString *messageId = aUserInfo[YWConversationMessageCustomMenuItemUserInfoKeyMessageId]; /// 获取长按的MessageId
                    YWConversationViewController *conversationController = aUserInfo[YWConversationMessageCustomMenuItemUserInfoKeyController]; /// 获取会话Controller
                    id<IYWMessage> message = [conversationController.conversation fetchMessageWithMessageId:messageId];
                    message = [message conformsToProtocol:@protocol(IYWMessage)] ? message : nil;
                    if ([[message messageBody] isKindOfClass:[YWMessageBodyImage class]]) {
                        YWMessageBodyImage *bodyImage = (YWMessageBodyImage *)[message messageBody];
                        NSArray *forRetain = @[bodyImage];
                        [bodyImage asyncGetOriginalImageWithProgress:^(CGFloat progress) {
                            ;
                        } completion:^(NSData *imageData, NSError *aError) {
                            /// 下载成功后保存
                            UIImage *img = [UIImage imageWithData:imageData];
                            if (img) {
                                UIImageWriteToSavedPhotosAlbum(img, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                            }
                            [forRetain count]; /// 用于防止bodyImage被释放
                        }];
                    }
                }];
                [result addObject:item];
            }
        }
        
        [result addObject:[weakController fetchLongPressItemForTimeControl]];
        [result addObject:[weakController fetchLongPressItemForEditMode]];
        
        return result;
    }];
    
    /// 设置多选模式菜单项
    [self exampleSetMenuForEditModeToConversationController:aConversationController];
}

#pragma mark - events

/**
 *  监听新消息
 */
- (void)exampleListenNewMessage
{
    [[self.ywIMKit.IMCore getConversationService] addOnNewMessageBlockV2:^(NSArray *aMessages, BOOL aIsOffline) {
        
        /// 你可以在此处根据需要播放提示音
        
        /// 展示透传消息
        [aMessages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
        }];
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

/**
 *  监听自己发送的消息的生命周期
 */
- (void)exampleListenMyMessageLife
{
    [[self.ywIMKit.IMCore getConversationService] addMessageLifeDelegate:self forPriority:YWBlockPriorityDeveloper];
}

/// 当你监听了消息生命周期，IMSDK会回调以下两个函数
- (YWMessageLifeContext *)messageLifeWillSend:(YWMessageLifeContext *)aContext
{
    /// 你可以通过返回context，来实现改变消息的能力
    if ([aContext.messageBody isKindOfClass:[YWMessageBodyText class]]) {
        NSString *text = [(YWMessageBodyText *)aContext.messageBody messageText];
        if ([text rangeOfString:@"发轮功事件"].location != NSNotFound) {
            YWMessageBodySystemNotify *bodyNotify = [[YWMessageBodySystemNotify alloc] initWithContent:@"消息包含违禁词语"];
            [aContext setMessageBody:bodyNotify];
            
            NSDictionary *params = @{kYWMsgCtrlKeyClientLocal:@{kYWMsgCtrlKeyClientLocalKeyOnlySave:@(YES)}};
            [aContext setControlParameters:params];
            
            return aContext;
        }
    }
    return nil;
}

- (void)messageLifeDidSend:(NSString *)aMessageId conversationId:(NSString *)aConversationId result:(NSError *)aResult
{
    /// 你可以在消息发送完成后，做一些事情，例如播放一个提示音等等
}

/**
 *  链接点击事件
 */
- (void)exampleListenOnClickUrl
{
    __weak __typeof(self) weakSelf = self;
    [self.ywIMKit setOpenURLBlock:^(NSString *aURLString, UIViewController *aParentController) {
        /// 您可以使用您的容器打开该URL

        if ([aURLString hasPrefix:@"tel:"]) {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:aURLString]]) {
                NSString *phoneNumber = [aURLString stringByReplacingOccurrencesOfString:@"tel:" withString:@""];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"拨打电话"
                                                                    message:phoneNumber
                                                                   delegate:weakSelf
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"呼叫", nil];
                alertView.tag = kSPAlertViewTagPhoneCall;
                [alertView show];
            }
        }
        else {
            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"^\\w+:" options:kNilOptions error:NULL];
            if ([regularExpression numberOfMatchesInString:aURLString options:NSMatchingReportCompletion range:NSMakeRange(0, aURLString.length - 1)] == 0) {
                aURLString = [NSString stringWithFormat:@"http://%@", aURLString];
            }
            YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:aURLString andImkit:[SPKitExample sharedInstance].ywIMKit];
            [aParentController.navigationController pushViewController:controller animated:YES];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kSPAlertViewTagPhoneCall) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            NSString *phoneNumber = alertView.message;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

/**
 *  预览大图事件
 */
- (void)exampleListenOnPreviewImage
{
    __weak typeof(self) weakSelf = self;
    
    [self.ywIMKit setPreviewImageMessageBlockV3:^(id<IYWMessage> aMessage, YWConversation *aOfConversation, NSDictionary *aFromUserInfo) {
        // 打开IMSDK提供的预览大图界面
        [YWImageBrowserHelper previewImageMessage:aMessage conversation:aOfConversation inNavigationController:[aFromUserInfo[YWUIPreviewImageMessageUserInfoKeyFromController] navigationController] fromView:aFromUserInfo[YWUIPreviewImageMessageUserInfoKeyFromView] additionalActions:nil withIMKit:weakSelf.ywIMKit];
    }];
}


#pragma mark - apns

/**
 *  您需要在-[AppDelegate application:didFinishLaunchingWithOptions:]中第一时间设置此回调
 *  在IMSDK截获到Push通知并需要您处理Push时，IMSDK会自动调用此回调
 */
- (void)exampleHandleAPNSPush
{
    __weak typeof(self) weakSelf = self;
    
    [[[YWAPI sharedInstance] getGlobalPushService] addHandlePushBlockV4:^(NSDictionary *aResult, BOOL *aShouldStop) {
        BOOL isLaunching = [aResult[YWPushHandleResultKeyIsLaunching] boolValue];
        UIApplicationState state = [aResult[YWPushHandleResultKeyApplicationState] integerValue];
        NSString *conversationId = aResult[YWPushHandleResultKeyConversationId];
        Class conversationClass = aResult[YWPushHandleResultKeyConversationClass];
        
        
        if (conversationId.length <= 0) {
            return;
        }
        
        if (conversationClass == NULL) {
            return;
        }
        
        if (isLaunching) {
            /// 用户划开Push导致app启动
            
        } else {
            /// app已经启动时处理Push
            
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

#pragma mark - EService

/**
 *  获取EService对象
 */
- (YWPerson *)exampleFetchEServicePersonWithPersonId:(NSString *)aPersonId groupId:(NSString *)aGroupId
{
    YWPerson *person = [[YWPerson alloc] initWithPersonId:aPersonId EServiceGroupId:aGroupId baseContext:self.ywIMKit.IMCore];
    return person;
}

@end
