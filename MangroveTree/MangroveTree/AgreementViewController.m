//
//  AgreementViewController.m
//  mgmanager
//
//  Created by 刘超 on 15/5/4.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@property (retain, nonatomic) UIScrollView *scrollView;

/**
 * @abstract 注册协议
 */
@property (strong, nonatomic) IBOutlet UIView *agreement1;
/**
 * @abstract 预订须知
 */
@property (strong, nonatomic) IBOutlet UIView *agreement2;
/**
 * @abstract 项目指数和计算公式
 */
@property (strong, nonatomic) IBOutlet UIView *agreement3;
/**
 * @abstract 预订日期
 */
@property (strong, nonatomic) IBOutlet UIView *agreement4;

@end

@implementation AgreementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.scrollView = (UIScrollView *)self.view;
    [self.agreement1 setFrame:CGRectMake(0, 0, kScreenWidth, self.agreement1.frame.size.height)];
    [self.agreement2 setFrame:CGRectMake(0, 0, kScreenWidth, self.agreement2.frame.size.height)];
    [self.agreement3 setFrame:CGRectMake(0, 0, kScreenWidth, self.agreement3.frame.size.height)];
    [self.agreement4 setFrame:CGRectMake(0, 0, kScreenWidth, self.agreement4.frame.size.height)];
    
    //返回按钮
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                    target:self
                                                                                    action:@selector(backButtonAction)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    self.title = self.titleLabel;
    
    //显示的内容
    [self setupContent];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 用户操作

//退出当前模态视图
- (void)backButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private functions

//显示不同的视图及内容
- (void)setupContent
{
    if ([_type isEqualToString:@"1"])
    {
        //注册协议
        [self.scrollView addSubview:_agreement1];
        [self.scrollView setContentSize:_agreement1.frame.size];
    }
    else if ([_type isEqualToString:@"2"])
    {
        //预订
        [self.scrollView addSubview:_agreement2];
        [self.scrollView setContentSize:_agreement2.frame.size];
    }
    else if ([_type isEqualToString:@"3"])
    {
        //项目指数和计算公式
        [self.scrollView addSubview:_agreement3];
        [self.scrollView setContentSize:_agreement3.frame.size];
    }
    else if ([_type isEqualToString:@"4"])
    {
        //预订日期
        [self.scrollView addSubview:_agreement4];
        [self.scrollView setContentSize:_agreement4.frame.size];
    }
}

@end
