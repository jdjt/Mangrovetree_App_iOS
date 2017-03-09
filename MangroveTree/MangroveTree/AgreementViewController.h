//
//  AgreementViewController.h
//  mgmanager
//
//  Created by 刘超 on 15/5/4.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreementViewController : UIViewController

/**
 * @abstract 协议标题
 */
@property (nonatomic,strong) NSString *titleLabel;

/**
 * @abstract 协议区分
 */
@property (nonatomic,strong) NSString *type;

@end
