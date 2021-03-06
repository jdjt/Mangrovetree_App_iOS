//
//  CenterViewController.m
//  mgmanager
//
//  Created by chao liu on 16/11/24.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FrameViewController.h"
#import "MapSearchViewController.h"
#import "MapViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"
#import "FMView.h"
#import "FMZoneManager.h"
#import "ChatViewController.h"
#import "MarqueeLabel.h"
#import "BindRoomViewController.h"

NSString* const FMModelSelected = @"FMModelSelected";

@interface FrameViewController () <MTRequestNetWorkDelegate,UIActionSheetDelegate>

// 地图数据相关
@property (nonatomic, strong) FMZoneManager * myZoneManager;
@property (strong, nonatomic) FMLocationBuilderInfo *waiterLocation;
@property (strong, nonatomic) FMLocationBuilderInfo *mySelfLocation;

// UI
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIView *loginAlertView;
@property (weak, nonatomic) IBOutlet UIView *loginAlertTapView;
@property (weak, nonatomic) IBOutlet MarqueeLabel *topAlertView;
// 底部栏
@property (weak, nonatomic) IBOutlet UIView *toSearchView;
@property (weak, nonatomic) IBOutlet UIView *toWorldPlatform;
@property (weak, nonatomic) IBOutlet UIView *toCallService;
@property (weak, nonatomic) IBOutlet UIImageView *toSearchImage;
@property (weak, nonatomic) IBOutlet UIImageView *toWorldPlatformImage;
@property (weak, nonatomic) IBOutlet UIImageView *toCallServiceImage;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

// 导航栏 按钮
@property (retain, nonatomic) UIBarButtonItem *userBarBtn;
@property (nonatomic, retain) NSTimer *countDownTimer;

@property (nonatomic, assign) NSInteger segmentSelect;
@property (nonatomic, assign) BOOL isLoginCheckBind;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottombarConstraint;
@property (nonatomic, strong) NSURLSessionTask * checkBind;
@property (nonatomic, strong) NSURLSessionTask * loginTask;
@property (nonatomic, strong) NSURLSessionTask * proceedTask;
@property (nonatomic, strong) NSURLSessionTask * customDetailTask;

@end

@implementation FrameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.goChat = NO;

	[UIApplication sharedApplication].idleTimerDisabled = YES;//不自动锁屏
    
    [self addUI];
    
    [self addGestureRecognizer];
    
    [self addNotification];
    
    [[MTRequestNetwork defaultManager] registerDelegate:self];
    // 检查是否登录
    BOOL login = [[DataManager defaultInstance] findLocationUserPersonalInformation];
    // 在这里开始发送网络请求
    if (login == YES)
        [self updateFromNetwork];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.currentTask != nil)
    {
        if (self.currentTask.waiterDeviceId != nil && ![self.currentTask.waiterDeviceId isEqualToString:@""]) {
            [self addLocationOnMap:self.currentTask];
        }
    }
    //[MBProgressHUD hideAllHUDsForView:[AppDelegate sharedDelegate].window animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[MBProgressHUD hideAllHUDsForView:[AppDelegate sharedDelegate].window animated:YES];
	[_countDownTimer invalidate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegate sharedDelegate].currentModule = MODULE_DEFAULT;
    if (self.currentTask == nil)
        self.messageLabel.hidden = YES;
    else
    {
        self.messageLabel.hidden = NO;
        [self changeTaskStatusByCurrentTask:self.currentTask];
    }
    
    [self showBottomView:Segment_none];
    
    if (self.goChat == YES)
        [self goChatView];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;//自动锁屏
    
    [[FMLocationManager shareLocationManager] setMapView:nil];
    
    [[MTRequestNetwork defaultManager] registerDelegate:self];
    
    // 如果是第一次启动，首先显示欢迎页，然后弹出登录界面
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //引导页方法
        [self showWelcome];
    }
    else
    {
        // 检查是否登录
        BOOL infor = [[DataManager defaultInstance] findLocationUserPersonalInformation];
        if (infor == NO)
            [self showLogin];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
#pragma mark - init
- (void)addGestureRecognizer
{
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.toSearchView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.toWorldPlatform addGestureRecognizer:tap2];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.toCallService addGestureRecognizer:tap3];
    
    UITapGestureRecognizer * alertTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertSelect)];
    [self.loginAlertTapView addGestureRecognizer:alertTap];

}
- (void)addUI
{
    self.segmentSelect = NSNotFound;
    self.loginAlertView.layer.cornerRadius = 7.0f;
    self.loginAlertView.clipsToBounds = YES;
    
    self.topAlertView.pauseInterval = 0;
    self.topAlertView.alpha = 0.9f;
    self.topAlertView.bufferSpaceBetweenLabels = 30;
    self.topAlertView.textColor = [UIColor grayColor];
    self.topAlertView.font = [UIFont systemFontOfSize:18];
    self.topAlertView.Text = @"点击任意建筑 即可为您提供导航路线 您可以通过手势进行缩放 旋转地图及调整地图倾斜角";
    
    self.title = @"红树林导航";
    self.navigationItem.leftBarButtonItem = self.userBarBtn;
}
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToMain:) name:NotiBackToMain object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTopAlert:) name:NotiCloseTopAlert object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetCustomDetail) name:NotiResetCustomDetail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTaskStatus:) name:NotiCallTaskPushMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTaskStatus:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - nav

- (UIBarButtonItem *)userBarBtn
{
    if (_userBarBtn == nil)
    {
        _userBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toUser"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
    }
    return _userBarBtn;
}

- (void)alertSelect
{
    self.loginAlertView.hidden = YES;
    
    if (self.mapVC.fmView.mapFinish == NO)
    {
        MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:[AppDelegate sharedDelegate].window animated:YES];
        HUD.labelText = @"正在加载地图，请稍等";
        [HUD show:YES];
    }
}

#pragma mark - Notif

- (void)closeTopAlert:(NSNotification *)noti
{
    self.topAlertView.hidden = YES;
    self.loginAlertView.hidden = YES;
}

- (void)backToMain:(NSNotification *)notification
{
    NSObject* obj = [notification object];
    if (obj != nil && [obj isKindOfClass:[NSIndexPath class]])
    {
        UIStoryboard *userStoryBoard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        UIViewController *vc = nil;
        NSIndexPath *indexPath = (NSIndexPath *)obj;
        if (indexPath.section == 0)
        {
            switch (indexPath.row)
            {
                case 0:
                    //用户中心
                    vc = [userStoryBoard instantiateViewControllerWithIdentifier:@"sceneUser"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    break;
                    
                default:
                    break;
            }
            return;
        }
        switch (indexPath.section)
        {
            case 1:
                // 设置
                vc = [userStoryBoard instantiateViewControllerWithIdentifier:@"sceneSettings"];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            default:
                break;
        }
    }
}

- (void)showSettings:(UIBarButtonItem *)sender
{
////    BaseAlertViewController *view = [BaseAlertViewController alertWithAlertType:AlertType_callTaskComplete andWithWaiterId:@"11111"];
//    __weak typeof (self)weakSelf = self;
//
//    GradeViewController *view = [GradeViewController initWithGradeInfor:nil withClick:^(ClickType clickType, NSInteger score) {
//        NSLog(@"%ld %ld",(long)
//              clickType,(long)score);
//        [weakSelf dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }];
//    
//    [self presentViewController:view animated:YES completion:^{
//        
//    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowSettings object:sender];
}

#pragma mark - Action 

- (void)backHomeAction:(UIBarButtonItem *)bar
{
	if (![FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi)
	{
        for (UIViewController *view in self.mapVC.navigationController.viewControllers)
        {
            if ([view isKindOfClass:[SearchViewController class]])
            {
                [self showBottomView:Segment_toWhere];
                break;
            }
        }
        [self changNavViewStyleByLayerMode:NAVIVARTYPE_OUT];
        [self.mapVC.navigationController popViewControllerAnimated:YES];
	}
}

//搜索页面跳转消息
- (void)naviSearch:(UIBarButtonItem *)bar
{
    [self toSearchAction];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiCloseTopAlert object:nil];
    [self alertSelect];
    if (tap.view == self.toSearchView)
    {
        [self showBottomView:Segment_toWhere];
        //去哪跳转
        [self toSearchAction];
    }
    else if (tap.view == self.toWorldPlatform)
    {
//        [self showBottomView:Segment_toWorld];
        self.toSearchImage.image = [UIImage imageNamed:@"toSearch_default"];
        self.toWorldPlatformImage.image = [UIImage imageNamed:@"toWorld_act"];
        self.toCallServiceImage.image = [UIImage imageNamed:@"toCallService_default"];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"全球度假平台暂未开放使用，敬请期待！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self showBottomView:Segment_default];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (tap.view == self.toCallService)
    {
        [self showBottomView:Segment_toService];
        [self tapCallService];
    }
}

- (void)toSearchAction
{
    if (![FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi)
    {
        [self.mapVC.fmView stopNavi];
        [[FMLocationManager shareLocationManager] setMapView:nil];
        
        BOOL hasSearch = NO;
        
        for (UIViewController *view in self.mapVC.navigationController.viewControllers)
        {
            if ([view isKindOfClass:[SearchViewController class]])
            {
                hasSearch = YES;
                [self.mapVC.navigationController popToViewController:view animated:YES];
                break;
            }
        }
        if (hasSearch == NO)
        {
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainGround" bundle:nil];
            SearchViewController * search = [storyboard instantiateViewControllerWithIdentifier:@"searchView"];
            [self.mapVC.navigationController pushViewController:search animated:NO];
        }
    }
}

- (void)tapCallService
{
//    if ([FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.mapID == 0)
//    {
//        [MyAlertView showAlert:@""];
//    }else
//    {
//        [MyAlertView showAlert:@"服务上线准备中,敬请期待"];
//    }
//    [self.msgViewController sendCallRequest];
//    self.showMsg = !self.showMsg;
//    if (self.showMsg == YES)
//    {
//        [self performSegueWithIdentifier:@"showBind" sender:nil];
//    }else
//    {
    [self checkBindRoomInforByLoginCheck:NO];
//    }
    
}
// 显示登录界面
- (void)showLogin
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController *navi = (UINavigationController *) [storyBoard instantiateViewControllerWithIdentifier:@"loginNavi"];
    LoginViewController* loginVC = (LoginViewController*)[navi topViewController];
    loginVC.showStop = NO;
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)changNavViewStyleByLayerMode:(NaviBarType)type
{
    if (type == NAVIVARTYPE_MAP)
    {
        self.navigationItem.rightBarButtonItem = nil;
//        self.navigationItem.titleView = self.segmentCallOrNavigation;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backHomeAction:)];
    }
    else if (type == NAVIVARTYPE_IN)
    {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backHomeAction:)];
    }else if (type == NAVIVARTYPE_OUT)
    {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = self.userBarBtn;
    }
}

#pragma mark - Map

- (FMZoneManager *)myZoneManager
{
    if (!_myZoneManager)
    {
        _myZoneManager = [[FMZoneManager alloc] initWithMangroveMapView:nil];
    }
    return _myZoneManager;
}

- (void)addLocationOnMap:(DBCallTask *)task
{
    FMLocationBuilderInfo * info1 = [self getWaiterBuilderInfoByTask:task];
    FMLocationBuilderInfo * info2 = [self getMySeleBuilderInfoByTask:task];
    
    [[FMLocationManager shareLocationManager] addLocOnMap:info1];
    [[FMLocationManager shareLocationManager] addLocOnMap:info2];
    
    [self testDistanceByLocation1:info1 withLocation2:info2];
}

- (NSString *)getCurrentZoneName
{
    return [self.myZoneManager getCurrentZone].zone_name;
}

- (void)removeLocationOnMap:(DBCallTask *)task
{
    [[FMLocationManager shareLocationManager] removeLocOnMap:[self getWaiterBuilderInfoByTask:task]];
    [[FMLocationManager shareLocationManager] removeLocOnMap:[self getMySeleBuilderInfoByTask:task]];
    [FMLocationManager shareLocationManager].delegate = nil;
    [[FMLocationManager shareLocationManager] stopTestDistance];
    self.mySelfLocation = nil;
    self.waiterLocation = nil;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDelegateToMap" object:nil];
}

- (FMLocationBuilderInfo *)getWaiterBuilderInfoByTask:(DBCallTask *)task
{
    if (self.waiterLocation == nil)
    {
        self.waiterLocation = [[FMLocationBuilderInfo alloc] init];
        self.waiterLocation.loc_mac  = task.waiterDeviceId;
        self.waiterLocation.loc_desc = @"服务员信息";
        self.waiterLocation.loc_icon = @"waiter_lcon.png";
    }
    
    return self.waiterLocation;
}

- (FMLocationBuilderInfo *)getMySeleBuilderInfoByTask:(DBCallTask *)task
{
    if (self.mySelfLocation == nil)
    {
        self.mySelfLocation = [[FMLocationBuilderInfo alloc] init];
        self.mySelfLocation.loc_mac = [[DataManager defaultInstance]getParameter].diviceId;
        self.mySelfLocation.loc_desc = @"我的信息";
        self.mySelfLocation.loc_icon = @"clien_icon.png";
    }
    
    return self.mySelfLocation;
}

- (void)testDistanceByLocation1:(FMLocationBuilderInfo *)info1 withLocation2:(FMLocationBuilderInfo *)info2;
{
    [[FMLocationManager shareLocationManager] testDistanceWithLocation1:info1 location2:info2 distance:10];
    [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMap"])
    {
        UINavigationController *nav = [segue destinationViewController];
        self.mapVC = (MapViewController *)[nav topViewController];
        self.mapVC.centerVC = self;
    }else if ([segue.identifier isEqualToString:@"showBind"])
    {
        BindRoomViewController *vc = (BindRoomViewController *)[segue destinationViewController];
        vc.frameController = self;
    }
}

#pragma mark - Set

- (void)setFunction:(CurrentFunction)function
{
    switch (function)
    {
        case FUNCTION_DEFAULT:
            [self showBottomViewByFunction:NO];
            break;
        default:
            [self showBottomViewByFunction:YES];
            break;
    }
}

- (void)showBottomViewByFunction:(BOOL)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomBarView.hidden = !show;
    }];
    
}

- (void)showWelcome
{
#warning 引导页
    [self showLogin];
}

- (void)goChatView
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.frameViewController = self;
    if (self.currentTask)
        chat.currentTask = self.currentTask;
    [self.navigationController pushViewController:chat animated:YES];
    self.goChat = NO;
}

- (void)changeTaskStatusByCurrentTask:(DBCallTask *)task
{
    NSString *message = @"等待接单";
    self.messageLabel.hidden = NO;
    if ([task.taskStatus isEqualToString:@"0"])
        message = @"等待接单";
    else if ([task.taskStatus isEqualToString:@"1"] || [task.taskStatus isEqualToString:@"7"])
        message = @"正在进行";
    else if ([task.taskStatus isEqualToString:@"2"])
        message = @"已完成";
    else
        self.messageLabel.hidden = YES;
    self.messageLabel.text = message;
}

#pragma mark- Netkwork

- (void)startRequest:(NSURLSessionTask *)task
{
    NSLog(@"是否有加载当前代理方法");
}

- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.loginTask)
    {
        [self checkBindRoomInforByLoginCheck:YES];
    }
    else if (task == self.checkBind)
    {
        NSDictionary *dic = datas[0];
        
        if ([dic[@"retOk"] isEqualToString:@"0"])
        {
            if (self.isLoginCheckBind == YES)
            {
                DBBindCustom * bind = [[DataManager defaultInstance] getCustomerBingRoom];
                if (bind.customerId == nil || [bind.customerId isEqualToString:@""])
                    return;
                else
                {
                    //  获取正在进行中的任务
                    [self getProceedTaskLiskByCustom:bind.customerId andTaskStatus:@"1"];
                    //  获取用户详情
                    [self getCustomDetailBy:bind.customerId];
                }
            }
            else
            {
                [self goChatView];
            }
        }
        else if([dic[@"retOk"] isEqualToString:@"1"])
        {
            if (self.isLoginCheckBind == YES)
                return;
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
            self.navigationItem.backBarButtonItem = barButtonItem;
            [[DataManager defaultInstance] cleanCoreDatabyEntityName:@"DBBindCustom"];
            [[DataManager defaultInstance] saveContext];
            [self performSegueWithIdentifier:@"showBind" sender:nil];
        }
    }
    else if (task == self.proceedTask)
    {
        if (datas.count > 0)
        {
            self.currentTask = datas[0];
            [self changeTaskStatusByCurrentTask:self.currentTask];
        }
        else
        {
            if (self.currentTask)
            {
                [self removeLocationOnMap:self.currentTask];
                self.currentTask = nil;
            }
        }
    }
    else if (task == self.customDetailTask)
    {
        // 获取custom信息 不需要前端显示信息 
    }
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if (task == self.loginTask)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"自动登录失败，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showLogin];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (task == self.checkBind)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"获取绑房信息失败，请检查网络状态后重试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showBottomView:Segment_none];
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (task == self.proceedTask)
    {
        
    }
    else if (task == self.customDetailTask)
    {
        
    }
}

- (void)updateFromNetwork
{
#warning  重新登录流程    现只做了登录
    if ([Util isConnectionAvailable])
    {
        [self requestAutoLogin];
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"没有可用的网络，请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showLogin];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 更新登录
- (void)requestAutoLogin
{
    DBUserLogin *user =  [[DataManager defaultInstance] findUserLogInByCode:@"1"];
    if (user == nil //没有用户，返回
        || ([Util isEmptyOrNull:user.account]&&[Util isEmptyOrNull:user.email]) // 用户账号（手机号）和邮箱同时为空
        || [Util isEmptyOrNull:user.password]) // 没有用户密码
    {
        return;
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    [params setObject:user.account forKey:@"account"];
    [params setObject:user.password forKey:@"password"];
    self.loginTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                 webURL:@URI_LOGIN
                                                                 params:params
                                                             withByUser:YES
                                                       andOldInterfaces:YES];
}

- (void)checkBindRoomInforByLoginCheck:(BOOL)isLogin
{
    self.isLoginCheckBind = isLogin;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setValue:[Util macaddress] forKey:@"deviceId"];
    [params setValue:[Util deviceToken] forKey:@"deviceToken"];
    self.checkBind = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                webURL:URL_CHECKBINDROOM
                                                params:params
                                            withByUser:YES
                                      andOldInterfaces:YES];
}

- (void)getProceedTaskLiskByCustom:(NSString *)customId andTaskStatus:(NSString *)taskStatus
{
    NSDictionary * dic = @{@"customerId":customId,
                           @"taskStatus":taskStatus};
    self.proceedTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                   webURL:URL_GETTASK_TASKSTATUS
                                                                   params:dic
                                                               withByUser:YES
                                                         andOldInterfaces:YES];
}

- (void)getCustomDetailBy:(NSString *)customId
{
    NSDictionary * dic = @{@"customerId":customId};
    self.customDetailTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                        webURL:URL_GETCUSTOMINFO
                                                                        params:dic
                                                                    withByUser:YES
                                                              andOldInterfaces:YES];
}

- (void)showBottomView:(SegmentSelected)select
{
    switch (select)
    {
        case Segment_none:
        {
            self.toSearchImage.image = [UIImage imageNamed:@"toSearch_default"];
            self.toWorldPlatformImage.image = [UIImage imageNamed:@"toWorld_default"];
            self.toCallServiceImage.image = [UIImage imageNamed:@"toCallService_default"];
            self.segmentSelect = Segment_none;
        }
            break;
        case Segment_default:
        {
            self.toSearchImage.image = self.segmentSelect == Segment_toWhere ? [UIImage imageNamed:@"toSearch_act"] : [UIImage imageNamed:@"toSearch_default"];
            self.toWorldPlatformImage.image = self.segmentSelect == Segment_toWorld ? [UIImage imageNamed:@"toWorld_act"] : [UIImage imageNamed:@"toWorld_default"];
            self.toCallServiceImage.image = self.segmentSelect == Segment_toService ? [UIImage imageNamed:@"toCallService_act"] : [UIImage imageNamed:@"toCallService_default"];
        }
            break;
        case Segment_toWhere:
        {
            self.toSearchImage.image = [UIImage imageNamed:@"toSearch_act"];
            self.toWorldPlatformImage.image = [UIImage imageNamed:@"toWorld_default"];
            self.toCallServiceImage.image = [UIImage imageNamed:@"toCallService_default"];
            self.segmentSelect = Segment_toWhere;
        }
            break;
        case Segment_toWorld:
        {
            self.toSearchImage.image = [UIImage imageNamed:@"toSearch_default"];
            self.toWorldPlatformImage.image = [UIImage imageNamed:@"toWorld_act"];
            self.toCallServiceImage.image = [UIImage imageNamed:@"toCallService_default"];
            self.segmentSelect = Segment_toWorld;
        }
            break;
        case Segment_toService:
        {
            self.toSearchImage.image = [UIImage imageNamed:@"toSearch_default"];
            self.toWorldPlatformImage.image = [UIImage imageNamed:@"toWorld_default"];
            self.toCallServiceImage.image = [UIImage imageNamed:@"toCallService_act"];
            self.segmentSelect = Segment_toService;
        }
            break;
        default:
        {
            self.toSearchImage.image = [UIImage imageNamed:@"toSearch_default"];
            self.toWorldPlatformImage.image = [UIImage imageNamed:@"toWorld_default"];
            self.toCallServiceImage.image = [UIImage imageNamed:@"toCallService_default"];
            self.segmentSelect = Segment_none;
        }
            break;
    }
}

#pragma mark - notification

- (void)resetCustomDetail
{
    [self checkBindRoomInforByLoginCheck:YES];
}
- (void)changeTaskStatus:(NSNotification *)noti
{
    DBBindCustom * bind = [[DataManager defaultInstance] getCustomerBingRoom];
    if (bind.customerId == nil || [bind.customerId isEqualToString:@""])
        return;
    else
    {
        //  获取正在进行中的任务
        [self getProceedTaskLiskByCustom:bind.customerId andTaskStatus:@"1"];
    }
}
- (void)dealloc
{
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
	self.mapVC.fmView = nil;
	self.mapVC = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
