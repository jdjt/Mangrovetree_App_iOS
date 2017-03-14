//
//  NetworkInterface.h
//  MangroveTree
//
//  Created by 罗禹 on 2017/3/7.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#ifndef NetworkInterface_h
#define NetworkInterface_h

// 判断设备系统
#define IOS7            [[[UIDevice currentDevice] systemVersion]floatValue]>=7

// 获取屏幕的尺寸
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_MAX_LENGTH (MAX(kScreenWidth, kScreenHeight))
#define SCREEN_MIN_LENGTH (MIN(kScreenWidth, kScreenHeight))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6_7 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P_7P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define SCREENBOUNDS [UIScreen mainScreen].bounds

#define ratioX(x) ([UIScreen mainScreen].bounds.size.width/320.0 )* x

#define ratioY(y) ([UIScreen mainScreen].bounds.size.height/568.0 )* y

#define rgba(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]

#define FitCGRectMake(x , y , z , w )  CGRectMake(kScreenWidth*((x)/320.0), kScreenWidth*((y)/320.0), kScreenWidth*((z)/320.0), kScreenWidth*((w)/320.0))

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define _IPHONE80_ 80000

/// show hud view
#define ShowHudViewOnSelfViewWithMessage(msg)    [[HPDProgress defaultProgressHUD] showHUDOnView:self.view message:msg]
#define HideHPDProgress                                     [[HPDProgress defaultProgressHUD] hide]

#define ShowOMGToast(msg)                                   [OMGToast showWithText:msg bottomOffset:70 duration:1];


#define myNumbers  @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._\n"

// 友盟appkey
#define UM_APPKEY  @"565e92a0e0f55ace6600260f"

#define REQUEST_HEAD_NORMAL "http://"
#define REQUEST_HEAD_SCREAT "https://"

// 找回密码
#define URI_FINDPWD                         "/uum/mem/account/reset_password.json"

// 获取验证码
#define URI_GETUKEY                         "/uum/common/captcha/gain_captcha.json"

// 验证码验证
#define URI_CHECKUKEY                       "/uum/common/captcha/check_captcha.json"

// 日历指数
#define URI_CALENDAR_ARRAY                  "/housekeeper/bookhotal/asset/calendar_array.json"

// 楼宇信息查询
#define URI_BUILDING_INFO                   "/housekeeper/bookhotal/asset/buliding_array.json"

// 菜品列表
#define URI_FOOD_ARRAY                      "/catering/diningroom/asset/menu_array.json"

// 点餐参数查询
#define REPAST_PARAMS                       "/catering/diningroom/asset/param_array.json"

// 用户登陆
#define URI_LOGIN                           "/uum/mem/sso/login.json"

// 用户登出
#define URI_LOGOUT                          "/uum/mem/sso/logout.json"

// 会员信息
#define MEMBER_INFO                         "/uum/mem/account/member_info.json"

// 手机号绑定
#define URI_REBIND                          "/uum/mem/account/binding.json"

// 修改密码
#define URI_MODIFY_PWD                      "/uum/mem/account/modify_password.json"

// 修改个人资料
#define URI_MODIFY_MEMINFO                  "/uum/mem/account/modify_member.json"

//用户注册
#define URI_REGIST                          "/uum/mem/account/register.json"

// 即时通讯获取用户和服务员userid
#define URL_ACHIEVE_USERID                  @"/hotelservice/manage/service/get_im_user.json"

// 发送呼叫请求
#define URL_SEND_CALL                       @"/hotelservice/checkin/service/add_task.json"

// 取消呼叫请求
#define URL_CANCEL_CALL                     @"/hotelservice/checkin/service/cancel_task.json"

// 查看呼叫任务接口
#define URL_CHECK_CALL                      @"/hotelservice/checkin/service/task_progress_info.json"

// 确认任务接口
#define URL_TASK_CONFIRM                    @"/hotelservice/checkin/service/confirm_task"

#endif /* NetworkInterface_h */
