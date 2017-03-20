//
//  CenterViewController.m
//  mgmanager
//
//  Created by chao liu on 16/11/24.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FrameViewController.h"
#import "MapSearchViewController.h"
#import "MsgViewController.h"
#import "MapViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"
#import "FMView.h"

#import "FMZoneManager.h"

NSString* const FMModelSelected = @"FMModelSelected";

@interface FrameViewController () <MTRequestNetWorkDelegate>


@property (nonatomic, strong) FMZoneManager * myZoneManager;

@property (strong, nonatomic) FMLocationBuilderInfo *waiterLocation;
@property (strong, nonatomic) FMLocationBuilderInfo *mySelfLocation;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
// 底部栏
@property (weak, nonatomic) IBOutlet UIView *toSearchView;
@property (weak, nonatomic) IBOutlet UIView *toWorldPlatform;
@property (weak, nonatomic) IBOutlet UIView *toCallService;
@property (weak, nonatomic) IBOutlet UIImageView *toSearchImage;
@property (weak, nonatomic) IBOutlet UIImageView *toWorldPlatformImage;
@property (weak, nonatomic) IBOutlet UIImageView *toCallServiceImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContraint;

@property (strong, nonatomic) MsgViewController *msgViewController;

// 导航栏 按钮
@property (retain, nonatomic) UIBarButtonItem *searchBarButton;
@property (retain, nonatomic) UIBarButtonItem *reloadBarButton;
@property (retain, nonatomic) UIBarButtonItem *cancelBarButton;
@property (retain, nonatomic) UIBarButtonItem *userBarBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWConstraint;
@property (nonatomic, retain) NSTimer *countDownTimer;
@property (nonatomic, strong) NSURLSessionTask * loginTask;

@end

@implementation FrameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.bottomBarView.hidden = YES;
	[UIApplication sharedApplication].idleTimerDisabled = YES;//不自动锁屏
    
    self.messageView.hidden = YES;
    self.topConstraint.constant = kScreenHeight- 64;
    self.bottomContraint.constant = 64- kScreenHeight;

    //    self.segmentCallOrNavigation.selectedSegmentIndex = 0;
    self.title = @"红树林导航";
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.toSearchView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.toWorldPlatform addGestureRecognizer:tap2];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.toCallService addGestureRecognizer:tap3];
    
    self.navigationItem.leftBarButtonItem = self.userBarBtn;
    self.navigationItem.rightBarButtonItem = self.searchBarButton;
    //监听点击地图，获取模型内的poi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPoiNames:)  name:FMModelSelected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLoadFMMap:) name:NotiLoadFMMap object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToMain:) name:NotiBackToMain object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiChangeStatusBar object:@"1"];

    [[MTRequestNetwork defaultManager] registerDelegate:self];
    // 检查是否登录
    BOOL login = [[DataManager defaultInstance] findLocationUserPersonalInformation];
    // 在这里开始发送网络请求
    if (login == YES)
    {
        [self updateFromNetwork];
    }
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.currentTask != nil)
    {
        [self startMessageViewLoadBy:self.currentTask];
        if (self.currentTask.workDeviceId != nil && ![self.currentTask.workDeviceId isEqualToString:@""]) {
            [self addLocationOnMap:self.currentTask];
        }
    }
    [MBProgressHUD hideAllHUDsForView:[AppDelegate sharedDelegate].window animated:YES];
    if ([Util locationServicesEnabled] == NO)
    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提醒" message:@"使用酒店地图定位以及导航功能需要应用允许访问您当前的位置，是否前往设置打开GPS定位" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//                                 {
//                                     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                                 }];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//                                       {
//                                           
//                                       }];
//        
//        [alert addAction:cancelAction];
//        [alert addAction:action];
//        [self  presentViewController:alert animated:YES completion:^{
//            
//        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MBProgressHUD hideAllHUDsForView:[AppDelegate sharedDelegate].window animated:YES];
	[_countDownTimer invalidate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;//自动锁屏
    
    [[FMLocationManager shareLocationManager] setMapView:nil];
    
    [[MTRequestNetwork defaultManager] registerDelegate:self];
    
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"OPENMAP"];
    
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
    self.buttonWConstraint.constant = kScreenWidth/2;
    self.topConstraint.constant = kScreenHeight - 64;
    self.bottomContraint.constant = 64 - kScreenHeight;
    if (self.currentTask != nil)
    {
        [self showCallResult:YES];
    }

}

- (void)startMessageViewLoadBy:(DBCallTask *)task;
{
    self.lastSelectedIndex = 1;
    self.currentTask = task;
    [self showCallResult:YES];
    self.msgViewController.curentTask = task;
    [self.msgViewController startCountDown];
    [self changNavViewStyleByLayerMode:NAVIVARTYPE_CALL];
    // 已经接单的状态
    if ([self.currentTask.acceptStatus isEqualToString:@"1"])
    {
        // 任务被接受 获取用户和服务员友盟userid
        if (self.msgViewController.conversationView == nil)
        {
            [self.msgViewController loadUserID];
        }
    }
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

- (UIBarButtonItem *)searchBarButton
{
    if (_searchBarButton == nil)
    {
        _searchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_icon_navi"] style:UIBarButtonItemStylePlain target:self action:@selector(naviSearch:)];
    }
    return _searchBarButton;
}

- (UIBarButtonItem *)cancelBarButton
{
    if (_cancelBarButton == nil)
    {
        _cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelCallAction:)];
    }
    return _cancelBarButton;
}

- (UIBarButtonItem *)reloadBarButton
{
    if (_reloadBarButton == nil)
    {
        _reloadBarButton = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(reloadTaskAction:)];
    }
    return _reloadBarButton;
    
}

- (void)cancelCallAction:(UIBarButtonItem *)bar
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"确认取消任务？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.msgViewController getLastTaskListByType:0];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)getPoiNames:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    NSArray * poiNames = dic[@"poiNames"];
    NSString * modelName = dic[@"modelName"];
    [self showFMActionSheetViewByNames:poiNames modelName:modelName];
    
}

- (void)startLoadFMMap:(NSNotification *)noti
{
//    [self loadFMMap];
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

- (void)showFMActionSheetViewByNames:(NSArray *)poiNames modelName:(NSString *)modelName
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:modelName
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:nil];
    
    for (NSString * poiName in poiNames) {
        [actionSheet addButtonWithTitle:poiName];
    }
    [actionSheet addButtonWithTitle:@"取消"];
    //	actionSheet.cancelButtonIndex = actionSheet.numberOfButtons -1;
    [actionSheet showInView:self.view];
}

- (void)showSettings:(UIBarButtonItem *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowSettings object:sender];
}

- (void)backHomeAction:(UIBarButtonItem *)bar
{
	if (![FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi)
	{
        [self.mapVC.navigationController popViewControllerAnimated:YES];
	}
}

- (void)reloadTaskAction:(UIBarButtonItem *)bar
{
    [self.msgViewController getLastTaskListByType:1];
}

//搜索页面跳转消息
- (void)naviSearch:(UIBarButtonItem *)bar
{
    [self toSearchAction];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (tap.view == self.toSearchView)
    {
        self.toSearchImage.image = [UIImage imageNamed:@"toSearch_act"];
        self.toWorldPlatformImage.image = [UIImage imageNamed:@"toWorld_default"];
        self.toCallServiceImage.image = [UIImage imageNamed:@"toCallService_default"];
        //去哪跳转
        [self toSearchAction];
    }
    else if (tap.view == self.toWorldPlatform)
    {
        self.toSearchImage.image = [UIImage imageNamed:@"toSearch_default"];
        self.toWorldPlatformImage.image = [UIImage imageNamed:@"toWorld_act"];
        self.toCallServiceImage.image = [UIImage imageNamed:@"toCallService_default"];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"全球度假平台暂未开放使用，敬请期待！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.toWorldPlatformImage.image = [UIImage imageNamed:@"toWorld_default"];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (tap.view == self.toCallService)
    {
        self.toSearchImage.image = [UIImage imageNamed:@"toSearch_default"];
        self.toWorldPlatformImage.image = [UIImage imageNamed:@"toWorld_default"];
        self.toCallServiceImage.image = [UIImage imageNamed:@"toCallService_act"];
        [self tapCallService];
    }
}
- (void)toSearchAction
{
    if (![FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi)
    {
        MapSearchViewController *seaVC = [[MapSearchViewController alloc] init];
        seaVC.mapID = @(kOutdoorMapID).stringValue;
        [self.mapVC.fmView stopNavi];
        [[FMLocationManager shareLocationManager] setMapView:nil];
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainGround" bundle:nil];
        SearchViewController * search = [storyboard instantiateViewControllerWithIdentifier:@"searchView"];
        
        [self.mapVC.navigationController pushViewController:search animated:NO];
        
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
    [self.msgViewController sendCallRequest];
}

- (void)setLastSelectedIndex:(NSInteger)lastSelectedIndex
{
    _lastSelectedIndex = lastSelectedIndex;
//    self.segmentCallOrNavigation.selectedSegmentIndex = _lastSelectedIndex;
    NSString *name = @"(暂未获取到您当前的位置)";
    if ([self getCurrentZoneName] != nil && ![[self getCurrentZoneName] isEqualToString:@""])
    {
        name = [self getCurrentZoneName];
    }
    [self changeSegment:_lastSelectedIndex];
}

// 显示callview
- (void)showCallView:(BOOL)show
{
}

// 显示发送呼叫的结果
- (void)showCallResult:(BOOL)show
{
    self.messageView.hidden = !show;
    
    CGRect showRect = CGRectMake(0, kScreenHeight - 60, kScreenWidth, kScreenHeight-64);
    CGRect HiddenRect = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-64);
    self.msgViewController.messageLabel.hidden = self.msgViewController.messageLabel.text.integerValue > 0 ? NO : YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.messageView.frame = show ? showRect: HiddenRect;
//        self.topConstraint.constant = show ? kScreenHeight - 60 : kScreenHeight;
//        self.bottomContraint.constant = show ? 60 -kScreenHeight : -kScreenHeight;
    }];
}

// 显示聊天界面
- (void)showMsgView:(BOOL)show
{
    self.messageView.hidden = NO;
    self.msgViewController.showMessage = show;
    CGRect showRect = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    CGRect HiddenRect = CGRectMake(0, kScreenHeight - 64, kScreenWidth, kScreenHeight-64);
    [UIView animateWithDuration:0.25 animations:^{
        self.messageView.frame = show ? showRect:HiddenRect;
//        self.topConstraint.constant = show ? 0:kScreenHeight - 64;
//        self.bottomContraint.constant = show ? 0: 64 - kScreenHeight;
    }];
}

- (void)changeSegment:(NSInteger)selectedIndex
{
    // 地图模式
    if (selectedIndex == 0)
    {
        self.messageView.hidden = YES;
    }
    // 呼叫模式
    else if (selectedIndex == 1)
    {
        self.messageView.hidden = YES;
    }
}

- (void)changNavViewStyleByLayerMode:(NaviBarType)type
{
    if (type == NAVIVARTYPE_MAP)
    {
        self.navigationItem.rightBarButtonItem = self.searchBarButton;
//        self.navigationItem.titleView = self.segmentCallOrNavigation;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backHomeAction:)];
    }
    // 地图呼叫模式
    else if (type == NAVIVARTYPE_CALL)
    {
        self.navigationItem.leftBarButtonItem = self.cancelBarButton;
        self.navigationItem.rightBarButtonItem = self.reloadBarButton;
        self.title = @"呼叫任务";
    }else if (type == NAVIVARTYPE_IN)
    {
        self.navigationItem.rightBarButtonItem = self.searchBarButton;
        //        self.navigationItem.titleView = self.segmentCallOrNavigation;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backHomeAction:)];
    }else if (type == NAVIVARTYPE_OUT)
    {
        self.navigationItem.rightBarButtonItem = self.searchBarButton;
        self.navigationItem.leftBarButtonItem = self.userBarBtn;
    }
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
        self.waiterLocation.loc_mac  = task.workDeviceId;
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
        self.mySelfLocation.loc_mac = task.diviceId;
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

- (IBAction)goMyCurrentLocation:(id)sender
{
    BOOL inDoorMap = [[NSUserDefaults standardUserDefaults] boolForKey:@"inDoorMap"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiCurrentLocation object:@(inDoorMap)];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMsg"])
    {
        self.msgViewController = (MsgViewController *)[segue destinationViewController];
        self.msgViewController.centerVC = self;
    }
    else if ([segue.identifier isEqualToString:@"showMap"])
    {
        UINavigationController *nav = [segue destinationViewController];
        self.mapVC = (MapViewController *)[nav topViewController];
        self.mapVC.centerVC = self;
    }
}

- (FMZoneManager *)myZoneManager
{
	if (!_myZoneManager)
	{
		_myZoneManager = [[FMZoneManager alloc] initWithMangroveMapView:nil];
	}
	return _myZoneManager;
}

- (void)showWelcome
{
    
#warning 引导页
    [self showLogin];
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

#pragma mark- nekwork

- (void)startRequest:(NSURLSessionTask *)task
{
    NSLog(@"是否有加载当前代理方法");
}

- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.loginTask)
    {
//        [self loadFMMap];
    }
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if (task == self.loginTask)
    {
//        [self loadFMMap];
    }
}

- (void)updateFromNetwork
{
#warning  重新登录流程    现只做了登录
    [self requestAutoLogin];
}

- (void)loadFMMap
{
    MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:[AppDelegate sharedDelegate].window animated:YES];
    HUD.labelText = @"正在加载地图，请稍等";
    [HUD show:YES];
    sleep(5);
    [self.mapVC loadMap];
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

- (void)dealloc
{
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
	self.mapVC.fmView = nil;
	self.mapVC = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"______________________________");
}

@end
