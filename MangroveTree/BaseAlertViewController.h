//
//  BaseAlertViewController.h
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/4/11.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @abstract 弹窗类型 可用于初始化
 */
typedef NS_ENUM(NSInteger,BaseAlertType)
{
    AlertType_default            = 0,
    AlertType_callTask           = 1,
    AlertType_pushNoti           = 2,
};

@interface BaseAlertViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertHeight;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

// 根据标题等初始化
+ (instancetype)initWithHeadTitle:(NSString *)headTitle andWithCheckTitles:(NSArray *)checkTitles andWithButtonTitles:(NSArray *)buttonTitles andWithHeadImage:(UIImage *)image;

// 添加弹窗button点击事件 可传nil会默认返回 （一个按钮）
- (void)addTarget:(id)target andWithComfirmAction:(SEL)action;

// 添加弹窗button点击事件 可传nil会默认返回 （两个按钮）
- (void)addTarget:(id)target andWithComfirmAction:(SEL)action1 andWithCancelAction:(SEL)action2;

// 设置按钮两边边距
- (void)setButtonLeadingTrailingContants:(CGFloat)contant;

// 设置headimage大小
- (void)setHeadImageSize:(CGFloat)height;

// 设置label，button文字大小
- (void)setHeadTitleFont:(UIFont *)headTitleFont andWithButtonTitleFont:(UIFont *)buttonTitleFont;

@end

