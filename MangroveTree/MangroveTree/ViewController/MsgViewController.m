//
//  MsgViewController.m
//  mgmanager
//
//  Created by 刘超 on 16/3/2.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "MsgViewController.h"
#import "NSString+Addtions.h"
#import "TaskStatus.h"
#import "StatusWaiting.h"
#import "StatusWaitingExpired.h"
#import "StatusAccept.h"
#import "StatusAcceptExpired.h"
#import "StatusFinished.h"
#import "StatusFinishedExpired.h"
#import "GradingView.h"
#import "FrameViewController.h"

@interface MsgViewController ()<MTRequestNetWorkDelegate>

@property (weak, nonatomic) IBOutlet UILabel *taskStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (retain, nonatomic) DBParameter *parameter;
@property (retain, nonatomic) TaskStatus *currentStatus;
// 倒计时
@property (nonatomic, retain) NSTimer *countDownTimer;
// 秒数
@property (nonatomic, assign) int time;
// 消息通知类型
@property (nonatomic, assign) NSString *messageType;
@property (nonatomic, retain) NSString *plistPath;
@property (nonatomic, assign) BOOL isMsgView;

@property (nonatomic, strong) NSURLSessionTask *getUserId;
@end

@implementation MsgViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.msgView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    self.parameter = [[DataManager defaultInstance] getParameter];
    self.conversationView = nil;
    self.showMessage = NO;
    self.isMsgView = NO;
    [self arrowImageChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMsgView:) name:NotiReloadCallMSg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeBackGround:) name:UIApplicationDidBecomeActiveNotification object:nil];
    if (self.curentTask.workNum != nil && ![self.curentTask.workNum isEqualToString:@""])
    {
         [self startCountDown];
    }
    self.timerLabel.text = @"00:00:00";
    [self taskStatusTransform];
    
    self.messageLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.messageLabel.layer.masksToBounds = YES;
    self.messageLabel.layer.borderWidth = 1.0f;
    self.messageLabel.layer.cornerRadius = 15.0f;
    
}

// 网络请求注册代理
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MTRequestNetwork defaultManager]registerDelegate:self];
}

// 网络请求注销代理
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[MTRequestNetwork defaultManager] removeDelegate:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MTRequestNetwork defaultManager] cancleAllRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 消息通知
- (void)reloadMsgView:(NSNotification *)not
{
    self.messageType = not.object;
    
    // 当前任务被接受
    if ([self.messageType isEqualToString:@"6"] || self.messageType == nil)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"消息通知" message:@"您的呼叫任务已被接单，服务员正火速赶来，请等待" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self getLastTaskListByType:1];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([self.messageType isEqualToString:@"3"])
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"消息通知" message:@"您的呼叫任务已被完成，谢谢您的使用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self getLastTaskListByType:1];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

// 设置箭头图片
- (void)arrowImageChange
{
    if (self.showMessage == NO)
    {
        self.arrowImage.image = [UIImage imageNamed:@"upImage"];
    }
    else
    {
        self.arrowImage.image = [UIImage imageNamed:@"downImage"];
    }
}

// 状态机填充数据
- (void)taskStatusTransform
{
    if (self.curentTask == nil)
        return;
    // 未完成
    if ([self.curentTask.status isEqualToString:@"0"])
    {
        // 接单进行中
        if (self.curentTask.workNum != nil && ![self.curentTask.workNum isEqualToString:@""])
            self.currentStatus = self.time > 300?[[StatusAcceptExpired alloc] init]:[[StatusAccept alloc] init];
        // 暂未接单
        else
            self.currentStatus = [[StatusWaiting alloc] init];
    }
    // 已完成
    else if ([self.curentTask.status isEqualToString:@"1"])
    {
        self.currentStatus = self.time > 300?[[StatusFinishedExpired alloc] init]:[[StatusFinished alloc] init];
    }
    // 已取消
    else if ([self.curentTask.status isEqualToString:@"9"])
    {
        if (self.curentTask.workNum != nil && ![self.curentTask.workNum isEqualToString:@""])
            self.currentStatus =  self.time > 300 ? [[StatusAcceptExpired alloc] init]:[[StatusAccept alloc] init];
        else
            self.currentStatus = [[StatusWaiting alloc] init];
    }
}

- (void)setCurrentStatus:(TaskStatus*)newStatus
{
    _currentStatus = newStatus;
    
    self.taskStatusLabel.text = newStatus.statusName;
    
    if ([self.curentTask.status isEqualToString:@"9"])
    {
        self.taskStatusLabel.text = @"已取消任务";
        return;
    }
    else if ([self.curentTask.status isEqualToString:@"1"])
    {
        self.taskStatusLabel.text = @"任务已完成";
        return;
    }
    
    if (newStatus.statusValue == STATUS_WAITING)
    {
        self.taskStatusLabel.text = @"等待接单中";
    }
    else if (newStatus.statusValue == STATUS_WAITING_EXPIRED)
    {
        self.taskStatusLabel.text = @"等待接单中（已超时）";
    }
    else if (newStatus.statusValue == STATUS_ACCEPT)
    {
        self.taskStatusLabel.text = [NSString stringWithFormat:@"%@ 为您服务",self.curentTask.workNum];
    }
    else if (newStatus.statusValue == STATUS_ACCEPT_EXPIRED)
    {
        self.taskStatusLabel.text = [NSString stringWithFormat:@"%@ 为您服务（已超时）",self.curentTask.workNum];
    }
    else if (newStatus.statusValue == STATUS_FINISH)
    {
        self.taskStatusLabel.text = @"任务已完成";
    }
    else if (newStatus.statusValue == STATUS_FINISH_EXPIRED)
    {
        self.taskStatusLabel.text = @"任务已完成（已超时）";
    }
}

// 定时器
- (void)startCountDown
{
    // 每秒刷新一次
    if (self.countDownTimer == nil)
    {
        [self allTime];
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                               target:self
                                                             selector:@selector(timerFired)
                                                             userInfo:nil
                                                              repeats:YES];
    }
}

- (void)timerFired
{
    [self allTime];
    self.time ++;
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", _time / 3600, (_time%3600)/60, _time % 60];
    self.timerLabel.textColor = _time > 300 ? [UIColor redColor] : [UIColor blackColor];
    [self taskStatusTransform];
}

- (void)resetUIAndFired
{
    self.time = 0;
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    [self taskStatusTransform];
    
}

- (void)newMessage:(NSNotification *)noti
{
    self.messageLabel.text = [NSString stringWithFormat:@"%ld",(long)self.conversation.conversationUnreadMessagesCount.integerValue];
    if (self.showMessageLabel == NO) {
        self.messageLabel.hidden = YES;
    }else{
        self.messageLabel.hidden = self.conversation.conversationUnreadMessagesCount.integerValue > 0 ? NO : YES;
    }
}

// 计算任务发出时间
- (void)allTime
{
    self.time = 0;
    NSString *datenow = [Util getTimeNow];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:self.curentTask.orderTime];
    NSDate *now = [formatter dateFromString:datenow];
    self.time = [now timeIntervalSince1970] - [date timeIntervalSince1970];
}

- (void)goBackGround:(NSNotification *)noti
{
    self.isMsgView = YES;
}

- (void)becomeBackGround:(NSNotification *)noti
{
    if (self.isMsgView == YES) {
        if (self.curentTask.workNum == nil || [self.curentTask.workNum isEqualToString:@""])
        {
            self.isMsgView = NO;
        }
    }
}

- (IBAction)tapHeader:(UITapGestureRecognizer *)sender
{
    if (self.showMessage == YES)
    {
        [self deallocInstantMessageing];
        [self.centerVC showCallResult:YES];
        [self.conversation markConversationAsRead];
        
        self.showMessageLabel = YES;
        self.showMessage = NO;
        self.messageLabel.hidden = YES;
        [self arrowImageChange];
        return;
    }
    // 有服务员接单的情况
    if (self.curentTask.workNum != nil && ![self.curentTask.workNum isEqualToString:@""] )
    {
        // 本地存在服务员即时通许参数时直接创建聊天界面，否则先获取聊天参数
        [self instantMessageingFormation];
        
        self.showMessageLabel = NO;
        self.messageLabel.hidden = YES;
        self.showMessage = YES;
        [self.centerVC showMsgView:YES];
        [self arrowImageChange];
    }
}

#pragma mark - NewWorkRequest

// 获取userid
- (void)loadUserID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"taskCode":self.curentTask.taskCode}];
    self.getUserId = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                 webURL:URL_ACHIEVE_USERID
                                                                 params:dic
                                                             withByUser:YES
                                                       andOldInterfaces:YES];
    
}

// 发送呼叫请求
- (void)sendCallRequest
{
    if (self.parameter.diviceId == nil || [self.parameter.diviceId isEqualToString:@""] )
    {
        __block NSString *macAddress;
        __weak typeof(self) weakSelf = self;
        MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:[AppDelegate sharedDelegate].window animated:YES];
        [HUD show:YES];
        [[FMDHCPNetService shareDHCPNetService] localMacAddress:^(NSString *macAddr)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:[AppDelegate sharedDelegate].window animated:YES];
            });
            macAddress = macAddr;
            if (macAddress != nil && ![macAddress isEqualToString:@""])
            {
                weakSelf.parameter.diviceId = macAddress;
                [[DataManager defaultInstance] saveContext];
                [weakSelf sendTaskRequst];
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MyAlertView showAlert:@"由于您当前未连接酒店Wi-Fi，因此无法使用酒店服务功能。"];
                });
            }
        }];
    }
    else
    {
        [self sendTaskRequst];
    }
}
- (void)sendTaskRequst
{
    NSString *zonename = @"0";
    if ([self.centerVC getCurrentZoneName] != nil && ![[self.centerVC getCurrentZoneName] isEqualToString:@""])
    {
        zonename = [self.centerVC getCurrentZoneName];
        
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:
                                @{@"diviceId": self.parameter.diviceId,
                                  @"location":zonename,
                                  @"locationDesc":zonename,
                                  @"locationArea":zonename,
                                  @"timeLimit":[Util getTimeNow],
                                  @"priority":@"0",
                                  @"patternInfo":@"0",
                                  @"category":@"0",
                                  @"deviceToken":self.parameter.deviceToken,
                                  @"messageInfo":@"呼叫服务"}];
    
    self.sengCallTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                    webURL:URL_SEND_CALL
                                                                    params:dic
                                                                withByUser:YES
                                                          andOldInterfaces:YES];
}
- (void)cancelCurrentTask
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                               @"diviceId":self.parameter.diviceId,
                                                                               @"taskCode":self.curentTask.taskCode,
                                                                               @"deviceToken":self.parameter.deviceToken}];
    
    self.cancelTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                  webURL:URL_CANCEL_CALL
                                                                  params:dic withByUser:YES
                                                        andOldInterfaces:YES];
}

- (void)getLastTaskListByType:(NSInteger)type;
{
    self.checkType = type;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"diviceId":self.parameter.diviceId,
                                                                               @"deviceToken":self.parameter.deviceToken,
                                                                               @"category":@"0"}];
    self.getLastTask  = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                    webURL:URL_CHECK_CALL
                                                                    params:dic
                                                                withByUser:YES
                                                          andOldInterfaces:YES];
}

- (void)confirmCurrentTaskWithScore:(NSString *)score andcurrenttask:(DBCallTask *)calltask
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"diviceId":[[DataManager defaultInstance] getParameter].diviceId,
                                                                               @"deviceToken":[[DataManager defaultInstance] getParameter].deviceToken,
                                                                               @"taskCode":calltask.taskCode,
                                                                               @"score":score}
                                ];
    self.confirmTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                   webURL:URL_TASK_CONFIRM
                                                                   params:dic
                                                               withByUser:YES
                                                         andOldInterfaces:YES];
}

#pragma mark - DataInterfaceDelegate

- (void)startRequest:(NSURLSessionTask *)task
{
}

- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.getUserId)
    {
        if (datas.count > 0) {
            self.curentTask.guestUserID = datas[0][@"cUserId"];
            self.curentTask.waiterUserID = datas[0][@"wUserId"];
            self.curentTask.waiterAppKey = datas[0][@"wAppkey"];
            [[DataManager defaultInstance]saveContext];
            // 构建聊天界面
            [self instantMessaging];
            [self instantMessageingFormation];
        }
    }// 呼叫任务
    else if (task == self.sengCallTask)
    {
        [self sendTaskNetWorkPushResponeResultsSucced:datas];
    }
    // 取消任务
    else if (task == self.cancelTask)
    {
        [self cancelTaskNetWorkPushResponeResultsSucced:datas];
    }
    else if (task == self.getLastTask)
    {
        self.curentTask = datas[0];
        self.centerVC.currentTask = datas[0];
        switch (self.checkType)
        {
            case CHECKTYPE_CANCEL:
                [self cancelCurrentTask];
                break;
            case CHECKTYPE_RELOAD:
                [self reloadNetWorkpushResponseResultsSucceed];
                break;
            default:
                break;
        }
    }
    else if (task == self.confirmTask)
    {
        if ([datas[0] isEqualToString:@"0"])
        {
            AppDelegate *appDelegate = [AppDelegate sharedDelegate];
            
            for (UIView *view in appDelegate.window.subviews)
            {
                if ([view isKindOfClass:[GradingView class]])
                {
                    view.hidden = YES;
                    [view removeFromSuperview];
                }
            }
        }else
        {
            [MyAlertView showAlert:@"评价失败了，请稍后重试"];
        }
    }
    
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if (task == self.confirmTask ||task == self.getLastTask||task == self.cancelTask||task == self.sengCallTask||task == self.getUserId)
    {
        [MyAlertView showAlert:msg];
    }
    
}

// 取消任务后的操作
- (void)cancelTaskDo
{
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"CallTaskMessageMemory"];
    self.showMessage = NO;
    //任务被完成后先将聊天对话所有未读消息置为已读（未读消息清零）
    [self.conversation markConversationAsRead];
    // 销毁聊天界面
    [self deallocInstantMessageing];
    self.showMessageLabel = NO;
    self.messageLabel.hidden = YES;
    self.taskStatusLabel.text = @"等待接单中";
    self.timerLabel.text = @"00:00:00";
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    //self.transitViewController.navigationItem.rightBarButtonItem = nil;
    [self arrowImageChange];
}

// 即时通讯登录
- (void)instantMessaging
{
    if (self.curentTask.guestUserID != nil && ![self.curentTask.guestUserID isEqualToString:@""])
    {
        [[SPKitExample sharedInstance]callThisAfterISVAccountLoginSuccessWithYWLoginId:self.curentTask.guestUserID passWord:@"sjlh2016" preloginedBlock:nil successBlock:^{
            YWPerson * person = [[YWPerson alloc]initWithPersonId:self.curentTask.waiterUserID appKey:self.curentTask.waiterAppKey];
            self.conversation = [YWP2PConversation fetchConversationByPerson:person creatIfNotExist:YES baseContext: [SPKitExample sharedInstance].ywIMKit.IMCore];
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"CallTaskMessageMemory"] isEqualToString:@"0"])
            {
                [self.conversation removeAllLocalMessages];
                [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"CallTaskMessageMemory"];
            }
            self.showMessageLabel = YES;
        } failedBlock:^(NSError * error) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"通讯模块登录失败" message:@"请检查网络状态重新登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self instantMessaging];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
}

// 创建及时通讯界面
- (void)instantMessageingFormation
{
    [self deallocInstantMessageing];
    
    self.conversationView = [[SPKitExample sharedInstance]exampleMakeConversationViewControllerWithConversation:self.conversation];
    self.conversationView.view.frame = CGRectMake(0,0, kScreenWidth, self.msgView.frame.size.height);
    [self.conversationView setMessageInputViewHidden:NO animated:NO];
    self.conversationView.backgroundImage = nil;
    self.conversationView.view.backgroundColor = [UIColor clearColor];
    self.conversationView.tableView.backgroundView = nil;
    self.conversationView.tableView.backgroundColor = [UIColor clearColor];
    
    self.messageLabel.text = [NSString stringWithFormat:@"%ld",(long)self.conversation.conversationUnreadMessagesCount.integerValue];
    [self addChildViewController:self.conversationView];
    [self.msgView addSubview: self.conversationView.view];
}

- (void)deallocInstantMessageing
{
    if (self.conversationView != nil) {
        
        [self.conversationView setMessageInputViewHidden:YES animated:NO];
        [self.conversationView.messageInputView removeFromSuperview];
        
        [self.conversationView.view removeFromSuperview];
        [self.conversationView removeFromParentViewController];
        self.conversationView = nil;
        
        for (id subview in self.msgView.subviews) {
            if ([subview isKindOfClass:[YWMessageInputView class]]) {
                [subview removeFromSuperview];
            }
        }
    }
}

// 刷新任务
- (void)reloadNetWorkpushResponseResultsSucceed
{
    // 当前任务被接单，开始倒计时
    if ([self.curentTask.acceptStatus isEqualToString:@"1"])
    {
        // 已接单  未完成 状态
        if ([self.curentTask.status isEqualToString:@"0"])
        {
            [self.centerVC addLocationOnMap:self.curentTask];
            // 任务被接受 获取用户和服务员友盟userid
            if (self.conversationView == nil)
            {
                [self startCountDown];
                [self loadUserID];
            }
        }
        // 已经取消 或者完成
        else
        {
            self.showMessage = NO;
            [self.conversation markConversationAsRead];
            [self deallocInstantMessageing];
            self.messageLabel.hidden = YES;
            self.showMessageLabel = NO;
            self.centerVC.lastSelectedIndex = 0;
            [self showGradingView:self.curentTask];
            [self resetUIAndFired];
            [self.centerVC changNavViewStyleByLayerMode:NAVIVARTYPE_MAP];
            [self.centerVC removeLocationOnMap:self.curentTask];
            [self.centerVC showCallView:YES];
            self.centerVC.currentTask = nil;
        }

    }
    // 未接单状态 （包括未接单已取消）
    else
    {
        // 未接单已取消逻辑
        if ([self.curentTask.status isEqualToString:@"9"])
        {
            [self cancelTaskDo];
            [self showGradingView:self.curentTask];
        }
    }
}

// 检查任务
- (void)checkNetWorkpushResponseResultsSucceed
{
    if ([self.curentTask.status isEqualToString:@"9"]||[self.curentTask.status isEqualToString:@"1"])
    {
        // 待确认
        if ([self.curentTask.confirmState isEqualToString:@"1"])
        {
            [self cancelTaskDo];
            [self showGradingView:self.curentTask];
        }
        self.showMessage = NO;
        [self cancelTaskDo];
        [self.centerVC showCallView:YES];
        //[self.fmView.fengMapView removeLocOnMap:self.waiterLocation];
    }
}

// 取消任务
- (void)cancelTaskNetWorkPushResponeResultsSucced:(NSMutableArray *)datas
{
    [self.centerVC showCallView:YES];
    [self.centerVC changNavViewStyleByLayerMode:NAVIVARTYPE_MAP];

    self.curentTask = datas[0];
    if ([self.curentTask.status isEqualToString:@"9"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CallTaskCodeMemory"];
        self.showMessage = NO;
        [self.conversation markConversationAsRead];
        [self deallocInstantMessageing];
        self.messageLabel.hidden = YES;
        self.showMessageLabel = NO;
        [self showGradingView:self.curentTask];
        [self.centerVC removeLocationOnMap:self.curentTask];
        self.centerVC.currentTask = nil;
    }
    [self resetUIAndFired];

}

// 发送任务
- (void)sendTaskNetWorkPushResponeResultsSucced:(NSMutableArray *)datas
{
    [self.centerVC showCallResult:YES];
    self.curentTask = datas[0];
    [[NSUserDefaults standardUserDefaults] setObject:self.curentTask.taskCode forKey:@"CallTaskCodeMemory"];
    self.curentTask.orderTime = [Util getTimeNow];
    self.curentTask.status = @"0";
    self.curentTask.deviceToken = [[DataManager defaultInstance] getParameter].deviceToken;
    self.curentTask.diviceId = [[DataManager defaultInstance] getParameter].diviceId;
    [self.centerVC changNavViewStyleByLayerMode:NAVIVARTYPE_CALL];
    [self taskStatusTransform];
    [self startCountDown];

}

- (void)showGradingView:(DBCallTask *)callTask
{
    if (![callTask.confirmState isEqualToString:@"0"])
    {
        TaskType type = TASK_NULL;
        // 未接单 已取消
        if ([callTask.acceptStatus isEqualToString:@"0"] && [callTask.status isEqualToString:@"9"])
        {
            type = TASK_NULL;
        }
        // 已接单 已取消
        else if ([callTask.acceptStatus isEqualToString:@"1"] && [callTask.status isEqualToString:@"9"])
        {
            type = TASK_CANCEL;
            
        }
        // 已接单，已完成
        else if ([callTask.acceptStatus isEqualToString:@"1"] && [callTask.status isEqualToString:@"1"])
        {
            type = TASK_FINISH;
        }
        GradingView *gradingView = [[GradingView alloc] initWithTaskType:type withTaskInfor:@{@"waiterInfor":type == TASK_NULL ? @"": self.curentTask.workNum,@"finishTime":type == TASK_NULL ? self.curentTask.cancelTime : self.curentTask.workFinishTime}];
        [gradingView showGradingView:YES];
        __weak MsgViewController *weakSelf = self;
        __weak GradingView *selfview = gradingView;
        
        gradingView.confirmBlock = ^void(NSString *score)
        {
            [weakSelf confirmCurrentTaskWithScore:score andcurrenttask:callTask];
            [selfview showGradingView:NO];
        };
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
