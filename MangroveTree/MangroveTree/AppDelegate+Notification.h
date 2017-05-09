//
//  AppDelegate+Notification.h
//  MangroveTree
//
//  Created by liuchao on 2017/5/9.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Notification)

- (void)setupUmengRemoteNotificationEnvironment:(NSDictionary *)launchOptions;

- (void)startNetWorkMonitoring;

- (void)showNotificationWith:(NSDictionary *)userInfo;

@end
