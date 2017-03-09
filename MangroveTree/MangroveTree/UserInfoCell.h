//
//  UserInfoCell.h
//  mgmanager
//
//  Created by 苏智 on 15/5/13.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell

/**
 * @abstract 用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *userAvator;

/**
 * @abstract 用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *userName;

/**
 * @abstract 会员等级
 */
@property (weak, nonatomic) IBOutlet UILabel *userLevel;

@end
