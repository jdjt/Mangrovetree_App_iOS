//
//  NewPhoneViewController.h
//  MangroveTree
//
//  Created by sjlh on 2017/3/10.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPhoneViewController : UITableViewController
/**
 * @abstract 唯一标识符
 */
@property (nonatomic,retain)NSString *uuid;

/**
 * @abstract 判断邮箱或者手机
 */
@property (nonatomic,retain)NSString *isPhoneOrEmail;

/**
 * @abstract 验证码
 */
@property (nonatomic,retain)NSString *code;

/**
 * @abstract 原账号
 */
@property (nonatomic,retain)NSString *account;

/**
 * @abstract 新账号
 */
@property (nonatomic,assign)BOOL newAccount;
@end
