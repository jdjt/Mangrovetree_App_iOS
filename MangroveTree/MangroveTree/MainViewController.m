//
//  MainViewController.m
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/3/9.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()


@property (nonatomic, assign) CGPoint lastPoint;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.UserView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.UserView.layer.shadowOffset = CGSizeMake(5, 0);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.shadowView addGestureRecognizer:tapGesture];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.UserView addGestureRecognizer:panGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings:) name:NotiShowSettings object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToMain:) name:NotiBackToMain object:nil];

}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}
// 处理在显示Settings层时，前景视图上的滑动手势
- (void)handleGesture:(UIGestureRecognizer *)sender
{
    // 判断禁止左滑或者右滑
    if (![sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        CGPoint lastPoint = [pan translationInView:self.view];
        if (lastPoint.x > 0)
        {
            return;
        }
    }
    
    if ([sender isKindOfClass:[UITapGestureRecognizer class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiBackToMain object:self];
    else if ([sender isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        switch (pan.state)
        {
            case UIGestureRecognizerStateBegan:
                self.lastPoint = [pan translationInView:self.view];
                break;
                
            case UIGestureRecognizerStateChanged:
            {
                CGPoint point = [pan translationInView:self.view];
                CGFloat offset = point.x - self.lastPoint.x;
                self.lastPoint = point;
                CGRect frame = self.UserView.frame;
                frame.origin.x += offset;
                frame.origin.x = fabs(frame.origin.x) > frame.size.width ? frame.size.width : frame.origin.x;
                frame.origin.x = fabs(frame.origin.x) < 0 ? 0 : frame.origin.x;
                self.UserView.frame = frame;
            }
                break;
                
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                CGRect frame = self.UserView.frame;
                if (fabs(self.lastPoint.x) > frame.size.width / 2)
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotiBackToMain object:self];
                else
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowSettings object:nil];
            }
                break;
                
            default:
                break;
        }
    }
}

// 显示个人中心
- (void)showSettings:(NSNotification *)notification
{
    self.shadowView.hidden = NO;
    CGRect rect = self.UserView.frame;
    rect.origin.x = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.UserView.frame = rect;
        self.shadowView.alpha = 0.5;
    }];
}

// 返回home
- (void)backToMain:(NSNotification *)notification
{
    CGRect rect = self.UserView.frame;
    rect.origin.x = -kScreenWidth * 3 / 4;
    [UIView animateWithDuration:0.2 animations:^{
        self.UserView.frame = rect;
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.shadowView setHidden:YES];  // 隐藏阴影
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toUser"])
    {
        UINavigationController * navi = [segue destinationViewController];
        self.userViewController = (UserViewController *)[navi topViewController];
    }
    else if ([segue.identifier isEqualToString:@"toMap"])
    {
        UINavigationController * navi = [segue destinationViewController];
        self.frameViewController = (FrameViewController *)[navi topViewController];
    }
}

@end
