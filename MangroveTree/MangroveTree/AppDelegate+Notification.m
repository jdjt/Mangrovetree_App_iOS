//
//  AppDelegate+Notification.m
//  MangroveTree
//
//  Created by liuchao on 2017/5/9.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "AppDelegate+Notification.h"
#import "UMessage.h"
#import "BaseAlertViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (Notification)
// 初始化友盟远程推送
- (void)setupUmengRemoteNotificationEnvironment:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    // Set AppKey and LaunchOptions
    [UMessage startWithAppkey:UM_APPKEY launchOptions:launchOptions];
    
    [UMessage registerForRemoteNotifications];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
        } else {
            //点击不允许
        }
    }];
    
    //调用此方法要注意对iOS10和iOS10以下进行不同的注册
    //[UMessage registerForRemoteNotifications:<#(nullable NSSet<UIUserNotificationCategory *> *)#> categories10:<#(nullable NSSet<UNNotificationCategory *> *)#>]
    // [UMessage registerForRemoteNotifications:<#(nullable NSSet<UIUserNotificationCategory *> *)#> categories10:<#(nullable NSSet<UNNotificationCategory *> *)#> withTypesForIos7:<#(UIRemoteNotificationType)#> withTypesForIos8:<#(UIUserNotificationType)#> withTypesForIos10:<#(UNAuthorizationOptions)#>]
    
    //  如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    //register remoteNotification types （iOS 8.0及其以上，iOS10以下版本）
    
    
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"category1";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    
    
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *tenaction1 = [UNNotificationAction actionWithIdentifier:@"tenaction1_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        
        UNNotificationAction *tenaction2 = [UNNotificationAction actionWithIdentifier:@"tenaction2_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *tencategory1 = [UNNotificationCategory categoryWithIdentifier:@"tencategory1" actions:@[tenaction2,tenaction1]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *tencategories = [NSSet setWithObjects:tencategory1, nil];
        
        [UMessage registerForRemoteNotifications:categories categories10:tencategories];
    }else
    {
        [UMessage registerForRemoteNotifications:categories categories10:nil];
    }
    //如果对角标，文字和声音的取舍，请用下面的方法
    //UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    //UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    //[UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
    //for log
    [UMessage setLogEnabled:YES];
}
- (void)startNetWorkMonitoring
{
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    self.networkStatus =  manager.networkReachabilityStatus;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
                 self.networkStatus = -1;
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 self.networkStatus = 0;
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 self.networkStatus = 1;
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 self.networkStatus = 2;
                 break;
             default:
                 break;
         }
     }];
}
- (void)showNotificationWith:(NSDictionary *)userInfo
{
    NSDictionary * pushMessage = userInfo;
    
    if ([pushMessage[@"messType"] isEqualToString:@"WaiterAcceptTask"]) //  服务员接受任务
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"NotiReceiveAlertFirst"];
        BaseAlertViewController *base = [BaseAlertViewController alertWithAlertType:AlertType_waiterOrderReceiving andWithWaiterId:@""];
        [base addTarget:self andWithComfirmAction:nil];
        [self.window.rootViewController presentViewController:base animated:YES completion:nil];
    }
    else if ([pushMessage[@"messType"] isEqualToString:@"WaiterConfirmTaskComplete"]) //  服务员完成任务
    {
        BaseAlertViewController *base = [BaseAlertViewController initWithHeadTitle:nil andWithDetail:@"您的呼叫管家已完成，请您确认，谢谢配合！" andWithCheckTitles:nil andWithButtonTitles:@[@"已完成"] andWithHeadImage:nil];
        [base addTarget:self andWithComfirmAction:nil];
        [self.window.rootViewController presentViewController:base animated:YES completion:nil];
    }
    else if ([pushMessage[@"messType"] isEqualToString:@"SystemAutoCancelTask"]) //  十分钟服务员未接单自动取消
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"NotiCancelAlertFirst"];
        BaseAlertViewController *base = [BaseAlertViewController alertWithAlertType:AlertType_systemAutoCancelTask andWithWaiterId:@""];
        [base addTarget:self andWithComfirmAction:@selector(refreshTaskStatus)];
        [self.window.rootViewController presentViewController:base animated:YES completion:nil];
    }
    else if ([pushMessage[@"messType"] isEqualToString:@"SystemAutoConfirmTaskToCustomer"]) //  三十分钟自动确认完成
    {
        BaseAlertViewController *base = [BaseAlertViewController initWithHeadTitle:nil andWithDetail:@"您的呼叫管家等待确认超时，系统默认已完成，请您对此次服务进行评价，谢谢！祝您入住愉快！" andWithCheckTitles:nil andWithButtonTitles:@[@"确 认"] andWithHeadImage:nil];
        [base addTarget:self andWithComfirmAction:nil];
        [self.window.rootViewController presentViewController:base animated:YES completion:nil];
    }
}

- (void)refreshTaskStatus
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiCallTaskPushMessage object:nil];
}

- (void)pushNotihandle:(NSDictionary *)userInfo
{
    switch (self.currentModule)
    {
        case MODULE_DEFAULT:
            [self showNotificationWith:userInfo];
            break;
        case MODULE_CHAT:
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiCallTaskPushMessage object:userInfo];
            break;
        default:
            break;
    }
}

@end
