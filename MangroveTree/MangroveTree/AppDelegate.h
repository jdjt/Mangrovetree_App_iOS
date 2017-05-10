//
//  AppDelegate.h
//  MangroveTree
//
//  Created by 罗禹 on 2017/3/7.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FunctionModule)
{
    MODULE_DEFAULT      = 0, // 聊天界面
    MODULE_CHAT         = 1, // 默认界面
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedDelegate;

@property (nonatomic, assign) NSInteger networkStatus;
@property (nonatomic, assign) FunctionModule currentModule;

@end

