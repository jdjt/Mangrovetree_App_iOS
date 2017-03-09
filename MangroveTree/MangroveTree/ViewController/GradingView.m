//
//  GradingView.m
//  mgmanager
//
//  Created by liuchao on 16/9/23.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "GradingView.h"
#import "Defaut_Enu.h"
#import "UIViewExt.h"

@interface GradingView ()

@property (nonatomic, assign) TaskType taskType;
@property (nonatomic, copy) NSString *waiterInfor;
@property (nonatomic, copy) NSString *finishTime;
@property (nonatomic, strong) NSString *score;
@end

@implementation GradingView

- (id)initWithTaskType:(TaskType)taskType withTaskInfor:(NSDictionary *)taskInfor
{
    self = [super init];
    
    if (self)
    {
        self.taskType = taskType;
        self.waiterInfor = taskInfor[@"waiterInfor"];
        self.finishTime  = taskInfor[@"finishTime"];
        self.score = @"0";
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    
    // 背景view
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.userInteractionEnabled = YES;
    bgView.center = self.center;
    bgView.bounds = CGRectMake(0, 0, kScreenWidth - 5, kScreenHeight/2);
    bgView.backgroundColor = [UIColor blackColor];
    bgView.clipsToBounds = YES;   
    bgView.layer.cornerRadius = 5.0f;
    bgView.alpha = 0.8;
    bgView.tag = 10001;   
    [self addSubview:bgView];
    
    // 任务标题
    UILabel *taskTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, bgView.width - 20, 44)];
    taskTitle.textAlignment = NSTextAlignmentCenter;
    taskTitle.font = [UIFont systemFontOfSize:18.0f];
    taskTitle.textColor = [UIColor whiteColor];
    NSString *text = [NSString stringWithFormat:@"当前呼叫任务已经%@",self.taskType == TASK_FINISH ? @"完成":@"取消"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string setColor:self.taskType == TASK_FINISH ? [UIColor redColor]:[UIColor orangeColor] Range:NSMakeRange(text.length -2 , 2)];
    taskTitle.attributedText = string;
    [bgView addSubview:taskTitle];
    
    // 服务infor
    NSArray *title = @[@"提供服务者",@"进行时间"];
    NSArray *infor = @[self.waiterInfor,self.finishTime];
    for (int i = 0; i < title.count; i ++)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.width/2*i, taskTitle.bottom, bgView.width/2, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 0)
            titleLabel.font = [UIFont systemFontOfSize:16.0f];
        else
            titleLabel.font = [UIFont systemFontOfSize:10.0f];
        
        titleLabel.text = title[i];
        titleLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:titleLabel];
        
        UILabel *inforLabel = [[UILabel alloc] initWithFrame:CGRectMake(i == 0 ? 10 : 10 + 20 + (bgView.width - 40)/2, titleLabel.bottom , (bgView.width - 40)/2, 44)];
        inforLabel.textAlignment = NSTextAlignmentCenter;
        inforLabel.font = [UIFont systemFontOfSize:12.0f];
        inforLabel.text = infor[i];
        inforLabel.backgroundColor = [UIColor grayColor];
        [bgView addSubview:inforLabel];
    }
    
    // 确定按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, bgView.height - 44, bgView.width, 44);
    [button setTitle:@"确 定" forState:UIControlStateNormal];
    button.tag = 1000;
    [button setBackgroundColor:[UIColor colorWithRed:81.0/256 green:150.0/256 blue:109.0/256 alpha:1]];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    // 无人接单 自己取消的情况下 不显示评分界面
    if (self.taskType == TASK_FINISH)
    {
        // 服务评价
        UILabel *gradingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, button.top - 60, 60, 44)];
        gradingLabel.textColor = [UIColor whiteColor];
        gradingLabel.font = [UIFont systemFontOfSize:14.0f];
        gradingLabel.text = @"服务评价";
        [bgView addSubview:gradingLabel];
        
        CGFloat buttonW = (bgView.width - 10 - gradingLabel.width -10)/5;
        
        // 星星视图
        for (int i = 1; i < 6; i ++)
        {
            UIButton *gradingButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [gradingButton setImage:[UIImage imageNamed:@"b27_icon_star_gray"] forState:UIControlStateNormal];
            gradingButton.frame = CGRectMake(gradingLabel.right + (i-1) * buttonW, button.top - 60, buttonW, buttonW);
            [gradingButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            gradingButton.tag = i +100;
            [bgView addSubview:gradingButton];
        }
        
        CGRect rect = gradingLabel.frame;
        rect.size.height = buttonW;
        gradingLabel.frame = rect;
    }
    
}

- (void)buttonAction:(UIButton *)button
{
    if (button.tag == 1000)
    {
        if (_confirmBlock)
        {
            _confirmBlock(_score);
        }
    }
    else
    {
        self.score = [NSString stringWithFormat:@"%ld",button.tag-100];
        UIView *bgView = [self viewWithTag:10001];
        for (UIView *view in bgView.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                UIButton *cuButton = (UIButton *)view;
                NSString *imageName = nil;
                if (cuButton.tag == 1000)
                    continue;
                
                if (cuButton.tag <= button.tag)
                    imageName = @"b27_icon_star_yellow";
                else
                    imageName = @"b27_icon_star_gray";
                
                [cuButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)showGradingView:(BOOL)show
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];

    if (show == YES)
    {
        for (UIView *view in appDelegate.window.subviews)
        {
            if ([view isKindOfClass:[self class]])
            {
                view.hidden = YES;
                [view removeFromSuperview];
            }else
            {
                self.hidden = NO;
                [appDelegate.window addSubview:self];
 
            }
        }

    }else
    {
        for (UIView *view in appDelegate.window.subviews)
        {
            if ([view isKindOfClass:[self class]])
            {
                view.hidden = YES;
                [view removeFromSuperview];
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
