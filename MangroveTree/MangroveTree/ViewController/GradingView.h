//
//  GradingView.h
//  mgmanager
//
//  Created by liuchao on 16/9/23.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBlock)(NSString *score);

typedef NS_ENUM(NSInteger,TaskType)
{
    TASK_FINISH,
    TASK_CANCEL,
    TASK_NULL,
};

@interface GradingView : UIView

@property (nonatomic, copy) ConfirmBlock confirmBlock;

/**
 * @abstract         创建评分界面
 * @param taskType   任务是取消还是完成
 * @param taskInfor  包含任务提供者/任务完成时间
 */
- (id)initWithTaskType:(TaskType)taskType withTaskInfor:(NSDictionary *)taskInfor;

- (void)showGradingView:(BOOL)show;

@end
