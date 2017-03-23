//
//  AppDelegate.m
//  MangroveTree
//
//  Created by 罗禹 on 2017/3/7.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "AppDelegate.h"
#import "UMessage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.firstInit = YES;
    
    // 定义系统状态栏默认风格
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UINavigationBar appearance] setBackgroundImage:[Util createImageWithColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.9]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:102 / 255.0f green:102 / 255.0f blue:102 / 255.0f alpha:1]];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:102 / 255.0f green:102 / 255.0f blue:102 / 255.0f alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName,nil]];
    
    // 开始网络状态监控
    [self startNetWorkMonitoring];
    // 通过调用数据管理器的单例来实现数据初始化
    [DataManager defaultInstance];
    
    // 设置友盟推送消息
    [self setupUmengRemoteNotificationEnvironment:launchOptions];
    
    // 友盟即时通讯sdk初始化
    [[SPKitExample sharedInstance] callThisInDidFinishLaunching];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *device = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    // 保存参数到本地
    DBParameter *paramenter = [[DataManager defaultInstance] getParameter];
    paramenter.deviceToken = device;
    [UMessage registerDeviceToken:deviceToken];
    [[[YWAPI sharedInstance] getGlobalPushService] setDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    
    [UMessage didReceiveRemoteNotification:userInfo];
//    self.messType = userInfo[@"messType"];
//    NSLog(@"通知消息:%@", userInfo);
//    if ([self.messType isEqualToString:@"2"]||[self.messType isEqualToString:@"7"]||[self.messType isEqualToString:@"8"])
//    {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"NewNotiCartTask" object:self.messType];
//    }
//    else
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotiReloadCallMSg object:self.messType];
//    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //直接点击应用图标进入app 根据角标来判断当前是否有新消息，如果处于呼叫界面，则有全屏提醒，未处于呼叫界面 会通知首页检查更新
    if (application.applicationIconBadgeNumber > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiReloadCallMSg object:nil];
        // 清除icon提示图标
        [application setApplicationIconBadgeNumber:0];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[DataManager defaultInstance] saveContext];
}

+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

// 初始化友盟远程推送
- (void)setupUmengRemoteNotificationEnvironment:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    // Set AppKey and LaunchOptions
    [UMessage startWithAppkey:UM_APPKEY launchOptions:launchOptions];
    
    [UMessage registerForRemoteNotifications];
    
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

@end
