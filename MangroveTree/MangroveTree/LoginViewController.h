//
//  LoginViewController.h
//  mgmanager
//
//  Created by 苏智 on 15/4/23.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UITableViewController<UITextFieldDelegate>

/**
 * @abstract 判断显示登录窗口还是注册窗口
 */
@property (assign, nonatomic) BOOL toRegist;

/**
 * @abstract 判断是否显示取消按钮
 */
@property (assign, nonatomic) BOOL showStop;

@property (strong, nonatomic) NSMutableDictionary * phoneUUIDDictionary;
@property (strong, nonatomic) NSMutableDictionary * registUUIDDictionary;

@end
