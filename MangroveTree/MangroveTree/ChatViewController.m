//
//  ChatViewController.m
//  MangroveTree
//
//  Created by liuchao on 2017/4/12.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatInputBar.h"
#import "ChatCell.h"
#import "PureLayout.h"
#import "ChatHeadView.h"
#import "NSString+Addtions.h"
#import "FrameViewController.h"
#import "ChatViewController+NetWork.h"
#import "GradeViewController.h"

#define kSizeHead CGSizeMake(kScreenWidth, 74)

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,SendMsgDelegate,MTRequestNetWorkDelegate>

@property (nonatomic, strong) UITableView *chatTabelView;
@property (nonatomic, strong) ChatInputBar *chatInputView;
@property (nonatomic, strong) ChatHeadView *headView;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UIBarButtonItem *cancelBarItem;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL reset;
@property (nonatomic, strong) NSString * comfirmStatus;
@property (nonatomic, strong) FMZoneManager *myZoneManager;
@property (nonatomic, strong) YWConversation * conversation;
@property (nonatomic, strong) YWConversationViewController * conversationView;
@property (nonatomic, strong) BaseAlertViewController * alert;

@property (nonatomic, assign) BOOL isSendTaskFail;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addUI];
    
    self.pageModelType = pageModel_NOTask;
    self.reset = NO;
    self.isSendTaskFail = NO;
    [self instantMessaging];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callTaskPush:) name:NotiCallTaskPushMessage object:nil];
    
    self.title = @"呼叫管家";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppDelegate sharedDelegate].currentModule = MODULE_CHAT;
    
    [[MTRequestNetwork defaultManager] registerDelegate:self];
    if (self.currentTask)
        [self getTaskDetailByTaskCode:self.currentTask.taskCode];
}
- (void)viewWillDisAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Getter Method

- (UITableView *)chatTabelView
{
    if (!_chatTabelView)
    {
        _chatTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
        _chatTabelView.delegate = self;
        _chatTabelView.dataSource = self;
        _chatTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTabelView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
    }
    return _chatTabelView;
}

- (ChatInputBar *)chatInputView
{
    if (!_chatInputView)
    {
        _chatInputView = [[ChatInputBar alloc] init];
        _chatInputView.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return _chatInputView;
}
- (ChatHeadView *)headView
{
    if (!_headView)
    {
        _headView = [[ChatHeadView alloc] init];
        _chatInputView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headView;
}
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (UIBarButtonItem *)cancelBarItem
{
    if (!_cancelBarItem)
    {
        _cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消呼叫" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTaskAction:)];
    }
    return _cancelBarItem;
}

- (DBBindCustom *)customBind
{
    if (_customBind == nil)
    {
        _customBind = [[DataManager defaultInstance] findUserLogInByCode:@"1"].hasCustomBind;
    }
    return _customBind;
}
- (FMZoneManager *)myZoneManager
{
    if (!_myZoneManager)
    {
        _myZoneManager = [[FMZoneManager alloc] initWithMangroveMapView:nil];
    }
    return _myZoneManager;
}
- (void)addUI
{
    [self.view addSubview:self.headView];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:74];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    [self.headView autoSetDimensionsToSize:kSizeHead];
    
    // add tableView
    [self.view addSubview:self.chatTabelView];
    self.chatTabelView.backgroundColor = [UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1];
    [self.chatTabelView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headView withOffset:0];
    [self.chatTabelView autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    
    // add inputView
    
    [self.view addSubview:self.chatInputView];
    [self.chatInputView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.chatTabelView];
    [self.chatInputView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.chatInputView autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    self.chatInputView.delegate = self;
    
    // textView 用来承载IM聊天界面
    self.textView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.textView];
    [self.textView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headView withOffset:0];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.textView autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    [self.textView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.textView.hidden = YES;

}
#pragma mark - UITableView  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count > 0)
    {
        NSDictionary *dic = self.dataSource[0];
        CGFloat height = [NSString heightFromString:dic[@"text"] withFont:[UIFont systemFontOfSize:18.0f]  constraintToWidth:kScreenWidth-8*2];
        return height +100;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChatCell" owner:nil options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1];
    if (self.dataSource.count > 0)
        cell.model = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell changAgainLocationWithReset:self.reset];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSendTaskFail == YES)
    {
        self.alert = [BaseAlertViewController initWithHeadTitle:nil andWithDetail:@"您的呼叫请求发送失败，是否重新发送？" andWithCheckTitles:nil andWithButtonTitles:@[@"取消",@"重新发送"] andWithHeadImage:nil];
        [self.alert addTarget:self andWithComfirmAction:@selector(againSengButtonAction:) andWithCancelAction:nil];
        [self presentViewController:self.alert animated:YES completion:nil];
    }
}

#pragma mark - FUNCTION

- (void)sendMsgByChatBarView:(NSString *)inputText
{
    if (self.dataSource.count > 0)
    {
        [MyAlertView showAlert:@"请耐心等待服务员为您服务"];
        [self.chatInputView inPutViewresignFirstResponder];
        return;
    }
    if (inputText != nil && ![inputText isEqualToString:@""])
    {
        NSString *are = @"菩提酒店";
        if ([self.myZoneManager getCurrentZone] != nil && ([self.myZoneManager getCurrentZone].zone_name != nil || ![[self.myZoneManager getCurrentZone].zone_name isEqualToString:@""]))
        {
            are = [self.myZoneManager getCurrentZone].zone_name;
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"请在获取到定位信息后再尝试发起呼叫服务" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        NSDictionary *dic = @{@"text":inputText,@"are":are,@"time":[Util getTimeNow]};
        [self.dataSource addObject:dic];
        [self.chatTabelView reloadData];
        self.headView.textStatus = TextStatus_waiting;
        [self sengMsgToSerive:inputText andAreaName:are];
        [self.chatInputView inPutViewresignFirstResponder];
    }
}

#pragma mark - Action

- (void)cancelTaskAction:(UIBarButtonItem *)bar
{
    [self cancelDesicListWithTastStatus:[self.currentTask.taskStatus isEqualToString:@"0"] ? @"1" : @"2"];
}

- (void)chooseCancelReason:(BaseAlertViewController *)sender
{
    if (self.currentTask == nil)
        return;
    [self cancelTask:sender.selectCauseCode andTaskCode:self.currentTask.taskCode];
}

- (void)againSengButtonAction:(UIButton *)button
{
    [self sengMsgToSerive:self.dataSource[0][@"text"] andAreaName:self.dataSource[0][@"are"]];
}

- (void)becomeActive
{
    if (self.currentTask != nil)
        [self getTaskDetailByTaskCode:self.currentTask.taskCode];
}

- (void)callTaskPush:(NSNotification *)noti
{
    NSDictionary * pushMessage = noti.object;
    if (self.currentTask == nil)
        return;
    if ([pushMessage[@"messType"] isEqualToString:@"WaiterAcceptTask"]) //  服务员接受任务
    {
        [self getTaskDetailByTaskCode:self.currentTask.taskCode];
    }
    else if ([pushMessage[@"messType"] isEqualToString:@"WaiterConfirmTaskComplete"]) //  服务员完成任务
    {
        [self getTaskDetailByTaskCode:self.currentTask.taskCode];
    }
    else if ([pushMessage[@"messType"] isEqualToString:@"SystemAutoCancelTask"]) //  十分钟服务员未接单自动取消
    {
        [self getTaskDetailByTaskCode:self.currentTask.taskCode];
    }
    else if ([pushMessage[@"messType"] isEqualToString:@"SystemAutoConfirmTaskToCustomer"]) //  三十分钟自动完成确认
    {
        [self getTaskDetailByTaskCode:self.currentTask.taskCode];
        BaseAlertViewController *base = [BaseAlertViewController initWithHeadTitle:nil andWithDetail:@"您的呼叫服务等待确认超时，系统默认服务已完成，谢谢！祝您入住愉快！" andWithCheckTitles:nil andWithButtonTitles:@[@"确 认"] andWithHeadImage:nil];
        [base addTarget:self andWithComfirmAction:nil];
        [self presentViewController:base animated:YES completion:nil];
    }
}

- (void)setUIByPageModelType:(pageModelType)pageModelType
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    long long timeLong = 0;
    
    if (self.pageModelType == pageModelType)
    {
        if (pageModelType == pageModel_NOReceive || pageModelType == pageModel_Complete  )
        {
            NSString * startTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"CallTaskStartTime"];
            if (startTime.length > 0)
            {
                timeLong = labs((NSInteger)[[formatter dateFromString:startTime] timeIntervalSinceNow]);
            }
            if (self.currentTask.produceTime.length > 0 && self.currentTask.nowDate.length > 0)
                timeLong = (self.currentTask.nowDate.longLongValue - self.currentTask.produceTime.longLongValue) / 1000;
            [self.headView startTaskTimerByStartTime:timeLong];
        }
        else if (pageModelType == pageModel_Receive)
        {
            [self.headView startTaskTimerByStartTime:(self.currentTask.nowDate.longLongValue - self.currentTask.acceptTime.longLongValue) / 1000];
        }
        return;
    }

    self.pageModelType = pageModelType;
    switch (pageModelType)
    {
        case pageModel_NOTask:
        {
            if (self.alert)
                [self.alert dismissViewControllerAnimated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CallTaskStartTime"];
            self.navigationItem.rightBarButtonItem = nil;
            [self.headView stopTimer];
            self.headView.textStatus = TextStatus_default;
            self.frameViewController.currentTask = nil;
            [self.dataSource removeAllObjects];
            [self.chatTabelView reloadData];
            self.textView.hidden = YES;
        }
            break;
        case pageModel_NOReceive:
        {
            NSString * startTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"CallTaskStartTime"];
            self.navigationItem.rightBarButtonItem = self.cancelBarItem;
            self.headView.textStatus = TextStatus_waiting;
            if (startTime.length > 0)
            {
                timeLong = labs((NSInteger)[[formatter dateFromString:startTime] timeIntervalSinceNow]);
            }
            else
            {
                timeLong = 0;
                [[NSUserDefaults standardUserDefaults] setObject:[Util getTimeNow] forKey:@"CallTaskStartTime"];
            }
            if (self.currentTask.produceTime.length > 0 && self.currentTask.nowDate.length > 0)
            {
                timeLong = ([self.currentTask.nowDate longLongValue] - [self.currentTask.produceTime longLongValue]) / 1000;
            }
            [self.headView startTaskTimerByStartTime:timeLong];
            
            if (self.currentTask.taskContent != nil && ![self.currentTask.taskContent isEqualToString:@""])
            {
                NSDate * resetTime = [NSDate dateWithTimeIntervalSince1970:(self.currentTask.produceTime.longLongValue / 1000)];
                NSDictionary *dic = @{@"text":self.currentTask.taskContent,@"are":self.currentTask.areaName,@"time":[formatter stringFromDate:resetTime]};
                [self.dataSource removeAllObjects];
                [self.dataSource addObject:dic];
                [self.chatTabelView reloadData];
            }
            
            self.textView.hidden = YES;
        }
            break;
        case pageModel_Complete:
        {
            self.navigationItem.rightBarButtonItem = self.cancelBarItem;
            if (self.alert != nil)
                [self.alert dismissViewControllerAnimated:YES completion:nil];
            self.alert = [BaseAlertViewController alertWithAlertType:AlertType_callTaskComplete andWithWaiterId:self.currentTask.waiterName];
            [self.alert addTarget:self andWithComfirmAction:@selector(comfirmTaskYES) andWithCancelAction:@selector(comfirmTaskNO)];
            [self presentViewController:self.alert animated:YES completion:nil];
        }
            break;
        case pageModel_Receive:
        {
            NSString * isFirstReceive = [[NSUserDefaults standardUserDefaults] objectForKey:self.currentTask.taskCode];
            if ([isFirstReceive isEqualToString:@"1"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:self.currentTask.taskCode];
                YWPerson * person = [[YWPerson alloc]initWithPersonId:self.currentTask.wImAccount appKey:@"23759225"];
                self.conversation = [YWP2PConversation fetchConversationByPerson:person creatIfNotExist:YES baseContext: [SPKitExample sharedInstance].ywIMKit.IMCore];
                [self.conversation asyncSendMessageBody:[[YWMessageBodyText alloc] initWithMessageText:self.currentTask.taskContent] controlParameters:nil progress:nil completion:nil];
            }
            
            NSString * isFirstAlert = [[NSUserDefaults standardUserDefaults] objectForKey:@"NotiReceiveAlertFirst"];
            if (![isFirstAlert isEqualToString:@"0"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"NotiReceiveAlertFirst"];
                self.alert = [BaseAlertViewController alertWithAlertType:AlertType_waiterOrderReceiving andWithWaiterId:self.currentTask.waiterName];
                [self.alert addTarget:self andWithComfirmAction:@selector(waiterReceiveTask)];
                [self presentViewController:self.alert animated:YES completion:nil];
            }
            else
            {
                [self waiterReceiveTask];
            }
        }
            break;
        case pageModel_waitGrade:
        {
            if (self.currentTask == nil)
                return;
            GradeViewController * view = [GradeViewController initWithGradeInfor:self.currentTask withClick:^(ClickType clickType, NSInteger score) {
                [self scoreTaskBy:self.currentTask.taskCode andScoreType:clickType == ClickType_Submit ? @"1" : @"2" andScore:clickType == ClickType_Submit ? [NSString stringWithFormat:@"%ld",(long)score] : @"5"];
            }];
            [self presentViewController:view animated:YES completion:nil];
        }
        case pageModel_systemCancel:
        {
            if (self.alert != nil)
                [self.alert dismissViewControllerAnimated:YES completion:nil];
            NSString * isCancelFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"NotiCancelAlertFirst"];
            if (![isCancelFirst isEqualToString:@"0"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"NotiCancelAlertFirst"];
                self.alert = [BaseAlertViewController alertWithAlertType:AlertType_systemAutoCancelTask andWithWaiterId:self.currentTask.waiterName];
                [self.alert addTarget:self andWithComfirmAction:@selector(systemAutoCancelTask)];
                [self presentViewController:self.alert animated:YES completion:nil];
            }
        }
            break;
        default:
            break;
    }
}

- (void)waiterReceiveTask
{
    self.navigationItem.rightBarButtonItem = self.cancelBarItem;
    [self instantMessageingFormation];
    self.headView.textStatus = TextStatus_proceed;
    [self.headView startTaskTimerByStartTime:(self.currentTask.nowDate.longLongValue - self.currentTask.acceptTime.longLongValue) / 1000];
    self.textView.hidden = NO;
}

- (void)systemAutoCancelTask
{
    [self setUIByPageModelType:pageModel_NOTask];
}

- (void)comfirmTaskYES
{
    self.comfirmStatus = @"2";
    [self comfirmTask:self.comfirmStatus andTaskCode:self.currentTask.taskCode];
}

- (void)comfirmTaskNO
{
    self.comfirmStatus = @"1";
    [self comfirmTask:self.comfirmStatus andTaskCode:self.currentTask.taskCode];
}

#pragma mark - network delegate

- (void)startRequest:(NSURLSessionTask *)task
{
    
}
- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.seesionSengTask)
    {
        // 发送任务成功
        NSDictionary * dic = datas[0];
        if ([dic[@"retOk"] isEqualToString:@"0"])
        {
            // 成功
            self.isSendTaskFail = NO;
            self.currentTask = [[DataManager defaultInstance] getCallTaskByTaskCode:dic[@"taskCode"]];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:self.currentTask.taskCode];
            if (self.frameViewController != nil)
                self.frameViewController.currentTask = self.currentTask;
            self.reset = NO;
            [self getTaskDetailByTaskCode:self.currentTask.taskCode];
        }
    }
    else if (task == self.cancelTaskSession)
    {
        // 取消任务成功 需要重置UI到发送任务时
        NSDictionary * dic = datas[0];
        if ([dic[@"retOk"] isEqualToString:@"0"])
        {
            // 成功
            self.currentTask = nil;
            [self setUIByPageModelType:pageModel_NOTask];
        }
    }
    else if (task == self.cancelListSession)
    {
        self.alert = [BaseAlertViewController alertWithAlertType:AlertType_cancelTaskReason andWithCheckTitles:datas andWithWaiterId:self.currentTask.waiterName];
        [self.alert addTarget:self andWithComfirmAction:@selector(chooseCancelReason:) andWithCancelAction:nil];
        [self presentViewController:self.alert animated:YES completion:nil];
    }
    else if (task == self.taskDeatilSession)
    {
        // 获取任务详情成功
        DBCallTask * callTask = datas[0];
        if ([callTask.taskStatus isEqualToString:@"1"] || [callTask.taskStatus isEqualToString:@"7"])
        {
            [self setUIByPageModelType:pageModel_Receive];
        }
        else if ([callTask.taskStatus isEqualToString:@"2"])
        {
            [self setUIByPageModelType:pageModel_Complete];
        }
        else if ([callTask.taskStatus isEqualToString:@"0"])
        {
            [self setUIByPageModelType:pageModel_NOReceive];
        }
        else if ([callTask.taskStatus isEqualToString:@"9"] && self.currentTask != nil)
        {
            [self setUIByPageModelType:pageModel_systemCancel];
        }
        else
        {
            [self setUIByPageModelType:pageModel_NOTask];
        }
    }
    else if (task == self.comfirmTaskSession)
    {
        if ([self.comfirmStatus isEqualToString:@"1"])
        {
            [self setUIByPageModelType:pageModel_Receive];
        }
        else
        {
            [self setUIByPageModelType:pageModel_waitGrade];
        }
    }
    else if (task == self.scoreTaskSession)
    {
        NSDictionary * dic = datas[0];
        if ([dic[@"retOk"] isEqualToString:@"0"])// 评价成功
            [self setUIByPageModelType:pageModel_NOTask];
        else
            [MyAlertView showAlert:@"评价失败，请检查网络"];
    }
    else if (task == self.getCustomDetailTask)
    {
        // 获取custom信息不需要前端显示
        [self instantMessaging];
    }
}
- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if (task == self.seesionSengTask)
    {
        self.reset = YES;
        self.isSendTaskFail = YES;
        [self.chatTabelView reloadData];
        self.alert = [BaseAlertViewController initWithHeadTitle:nil andWithDetail:@"您的呼叫请求发送失败，是否重新发送？" andWithCheckTitles:nil andWithButtonTitles:@[@"取消",@"重新发送"] andWithHeadImage:nil];
        [self.alert addTarget:self andWithComfirmAction:@selector(againSengButtonAction:) andWithCancelAction:nil];
        [self presentViewController:self.alert animated:YES completion:nil];
    }
    else if (task == self.cancelTaskSession)
    {
        [MyAlertView showAlert:@"取消服务失败，请检查网络状态"];
    }
    else if (task == self.cancelListSession)
    {
        // 获取取消原因失败
    }
    else if (task == self.taskDeatilSession)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"获取任务详情失败失败" message:@"请检查网络状态后重试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getTaskDetailByTaskCode:self.currentTask.taskCode];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (task == self.comfirmTaskSession)
    {
        
    }
    else if (task == self.scoreTaskSession)
    {
        [self setUIByPageModelType:pageModel_NOTask];
    }
    else if (task == self.getCustomDetailTask)
    {
        [MyAlertView showAlert:@"获取用户信息失败，请重新尝试，已便使用语音聊天与服务员即时沟通"];
    }
}

#pragma mark - 即时通讯

// 即时通讯登录
- (void)instantMessaging
{
    if (self.customBind.imAccount != nil && ![self.customBind.imAccount isEqualToString:@""])
    {
        [[SPKitExample sharedInstance]callThisAfterISVAccountLoginSuccessWithYWLoginId:self.customBind.imAccount passWord:@"sjlh2017" preloginedBlock:nil successBlock:^{

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
//    else
//    {
//        [self getCustomDetailByCustomId:_customBind.customerId];
//    }
}

// 创建及时通讯界面
- (void)instantMessageingFormation
{
    [self deallocInstantMessageing];
    
    YWPerson * person = [[YWPerson alloc]initWithPersonId:self.currentTask.wImAccount appKey:@"23759225"];
    self.conversation = [YWP2PConversation fetchConversationByPerson:person creatIfNotExist:YES baseContext: [SPKitExample sharedInstance].ywIMKit.IMCore];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"CallTaskMessageMemory"] isEqualToString:@"0"])
    {
        [self.conversation removeAllLocalMessages];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"CallTaskMessageMemory"];
    }
    
    self.conversationView = [[SPKitExample sharedInstance]exampleMakeConversationViewControllerWithConversation:self.conversation];
    self.conversationView.view.frame = CGRectMake(0,0, kScreenWidth, self.textView.frame.size.height);
    [self.conversationView.messageInputView beginListeningForKeyboard];
    self.conversationView.backgroundImage = nil;
    self.conversationView.edgesForExtendedLayout = UIRectEdgeNone;
    [self addChildViewController:self.conversationView];
    [self.textView addSubview: self.conversationView.view];
}

- (void)deallocInstantMessageing
{
    if (self.conversationView != nil) {
        
        [self.conversationView setMessageInputViewHidden:YES animated:NO];
        [self.conversationView.messageInputView removeFromSuperview];
        
        [self.conversationView.view removeFromSuperview];
        [self.conversationView removeFromParentViewController];
        self.conversationView = nil;
        
        for (id subview in self.textView.subviews) {
            if ([subview isKindOfClass:[YWMessageInputView class]]) {
                [subview removeFromSuperview];
            }
        }
    }
}

- (void)dealloc
{
    [[MTRequestNetwork defaultManager] cancleAllRequest];
    [[MTRequestNetwork defaultManager] removeDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
