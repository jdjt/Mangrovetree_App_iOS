//
//  MsgViewController.h
//  mgmanager
//
//  Created by 刘超 on 16/3/2.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,checkType)
{
    CHECKTYPE_CANCEL           = 0,
    CHECKTYPE_RELOAD           = 1,
};

@class FrameViewController;

@interface MsgViewController : UIViewController

@property (weak, nonatomic) FrameViewController *centerVC;;

/**
 * @abstract 当前呼叫任务
 */
@property (retain, nonatomic) DBCallTask *curentTask;
@property (assign, nonatomic) BOOL showMessage;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (assign, nonatomic) BOOL showMessageLabel;
@property (nonatomic,strong) YWConversation * conversation;
@property (nonatomic,strong) YWConversationViewController * conversationView;

@property (assign, nonatomic) checkType checkType;
@property (strong, nonatomic) NSURLSessionTask *sengCallTask;
@property (strong, nonatomic) NSURLSessionTask *cancelTask;
@property (nonatomic, strong) NSURLSessionTask *confirmTask;
@property (nonatomic, strong) NSURLSessionTask *getLastTask;

- (void)instantMessageingFormation;

- (void)arrowImageChange;

- (void)taskStatusTransform;


- (void)resetUIAndFired;

- (void)startCountDown;

// 销毁聊天页面
- (void)deallocInstantMessageing;

/**
 * @abstract 即时通讯登录
 */
- (void)instantMessaging;

/**
 * @abstract 取消呼叫任务后执行的操作
 */
- (void)cancelTaskDo;

- (void)loadUserID;

- (void)getLastTaskListByType:(NSInteger)type;

- (void)sendCallRequest;

- (void)cancelCurrentTask;


@end
