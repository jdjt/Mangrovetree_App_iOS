//
//  UserCell.h
//  mgmanager
//
//  Created by 刘超 on 15/4/30.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell

/**
 * @abstract 显示单元格图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *naviIconImage;

/**
 * @abstract 单元格标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
