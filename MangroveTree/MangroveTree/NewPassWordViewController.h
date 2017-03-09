//
//  NewPassWordViewController.h
//  mgmanager
//
//  Created by 刘超 on 15/5/5.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPassWordViewController : UITableViewController<UITextFieldDelegate,MTRequestNetWorkDelegate>

/**
 * @abstract 账号
 */
@property (nonatomic,strong)NSString *acctount;

/**
 * @abstract 验证码
 */
@property (nonatomic,strong)NSString *code;

/**
 * @abstract uuid  唯一标识符
 */
@property (nonatomic,strong)NSString *uuid;


@end
