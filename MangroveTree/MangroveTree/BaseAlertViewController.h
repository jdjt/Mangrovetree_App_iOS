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
    AlertType_systemAutoCancelTask              = 0, // 系统自动取消任务提示
    AlertType_callTaskComplete                  = 1, // 呼叫服务完成提示
    AlertType_cancelTaskReason                  = 2, // 取消呼叫任务弹窗
    AlertType_waiterOrderReceiving              = 3, // 服务员接单提示
};

@interface BaseAlertViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertHeight;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, assign) NSInteger selectTable;

// 根据标题等初始化
+ (instancetype)initWithHeadTitle:(NSMutableAttributedString *)headTitle andWithDetail:(NSString *)detail andWithCheckTitles:(NSArray *)checkTitles andWithButtonTitles:(NSArray *)buttonTitles andWithHeadImage:(UIImage *)image;

// 根据使用类型初始化(使用tableView选择框的)
+ (instancetype)alertWithAlertType:(BaseAlertType)alertType andWithCheckTitles:(NSArray *)checkTitles andWithWaiterId:(NSString *)waiterId;

// 根据使用类型初始化
+ (instancetype)alertWithAlertType:(BaseAlertType)alertType andWithWaiterId:(NSString *)waiterId;

// 添加弹窗button点击事件 可传nil会默认返回 （一个按钮）
- (void)addTarget:(id)target andWithComfirmAction:(SEL)action;

// 添加弹窗button点击事件 可传nil会默认返回 （两个按钮）
- (void)addTarget:(id)target andWithComfirmAction:(SEL)action1 andWithCancelAction:(SEL)action2;

// 设置headimage大小
- (void)setHeadImageSizes:(CGFloat)height;

// 设置label，button文字大小
- (void)setHeadTitleFont:(UIFont *)headTitleFont andDetailFont:(UIFont *)detailFont andWithButtonTitleFont:(UIFont *)buttonTitleFont;

// 设置headTitle 文字模式（居左，居中等）
- (void)setHeadTitleTextAlignment:(NSTextAlignment)textAlignment;

@end

