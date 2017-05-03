//
//  ChatViewController.h
//  MangroveTree
//
//  Created by liuchao on 2017/4/12.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameViewController.h"

@interface ChatViewController : UIViewController

/**
 * @abstract 页面模式
 */
typedef NS_ENUM(NSInteger,pageModelType)
{
    pageModel_NOTask        = 0,  // 没发任务
    pageModel_NOReceive     = 1,  // 未接单
    pageModel_Receive       = 2,  // 已接单
    pageModel_Complete      = 3,  // 服务员点击完成，需用户确认
    pageModel_waitGrade     = 4,  // 待评价
    pageModel_systemCancel  = 5,  // 系统自动取消
};

@property (nonatomic, strong) FrameViewController * frameViewController;

@property (nonatomic, strong) DBCallTask * currentTask;
@property (nonatomic, strong) DBBindCustom * customBind;

@property (nonatomic, assign) pageModelType pageModelType;
// 网络请求
@property (nonatomic, strong) NSURLSessionTask * seesionSengTask;
@property (nonatomic, strong) NSURLSessionTask * cancelTaskSession;
@property (nonatomic, strong) NSURLSessionTask * cancelListSession;
@property (nonatomic, strong) NSURLSessionTask * taskDeatilSession;
@property (nonatomic, strong) NSURLSessionTask * comfirmTaskSession;
@property (nonatomic, strong) NSURLSessionTask * scoreTaskSession;
@property (nonatomic, strong) NSURLSessionTask * getCustomDetailTask;


@end
