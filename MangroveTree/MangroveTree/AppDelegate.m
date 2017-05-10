//
//  AppDelegate.m
//  MangroveTree
//
//  Created by 罗禹 on 2017/3/7.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "AppDelegate.h"
#import "UMessage.h"
#import "AppDelegate+Notification.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.currentModule = MODULE_DEFAULT;
    
    // 定义系统状态栏默认风格
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UINavigationBar appearance] setBackgroundImage:[Util createImageWithColor:[UIColor colorWithHexString:@"#ED8256"]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"#ffffff"]];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#ffffff"],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName,nil]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
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
    if (userInfo)
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
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[FMKLocationServiceManager shareLocationServiceManager] stopLocationService];
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
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotiReloadCallMSg object:nil];
        // 清除icon提示图标
        [application setApplicationIconBadgeNumber:0];
    }
    [[FMKLocationServiceManager shareLocationServiceManager] restartLocationService];

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
- (void)setCurrentModule:(FunctionModule)currentModule
{
    if (_currentModule == currentModule)
    {
        _currentModule = currentModule;
    }
}

@end
