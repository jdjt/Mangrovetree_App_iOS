//
//  GradeViewController.m
//  MangroveTree
//
//  Created by liuchao on 2017/4/25.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "GradeViewController.h"
#import "AlertPresentAnimation.h"

@interface GradeViewController ()<UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UILabel *waiterNumber;
@property (weak, nonatomic) IBOutlet UILabel *tasktime;
@property (weak, nonatomic) IBOutlet UIView *gradeView;
@property (copy, nonatomic) BlockClick clickBlock;
@property (assign, nonatomic) NSInteger score;

@end

@implementation GradeViewController

+ (instancetype)initWithGradeInfor:(DBCallTask *)gradeInfor withClick:(BlockClick)click
{
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"BaseAlert" bundle:nil];
    GradeViewController * viewController = (GradeViewController *)[story instantiateViewControllerWithIdentifier:@"GradeViewController"];
    if (viewController)
    {
        viewController.transitioningDelegate = viewController;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
//            viewController.waiterNumber.text = gradeInfor[@"waiterNumber"];
//            viewController.tasktime.text = gradeInfor[@"tasktime"]
        viewController.clickBlock = click;
    }
    
    return viewController;
}

- (IBAction)baseButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag)
    {
        case 10005:
            if (_clickBlock)
            {
                _clickBlock(ClickType_Submit, _score);
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            break;
        default:
            [self changStarBackgroundImageByIndex:button.tag];
            break;
    }
}
- (IBAction)cancelButtonAction:(id)sender
{
    if (_clickBlock)
    {
        _clickBlock(ClickType_Cancel, _score);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)changStarBackgroundImageByIndex:(NSInteger)index
{
    self.score = index+1-10000;
    for (UIView *view in self.gradeView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)view;
            NSString *image = @"";
            if (button.tag <= index) image = @"hightstar";
            else image = @"defaultstar";
            [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    self.score = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [AlertPresentAnimation transitionWithTransitionType:PresentOneTransitionTypePresent];;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [AlertPresentAnimation transitionWithTransitionType:PresentOneTransitionTypeDismiss];;
}
- (void)dealloc
{
    NSLog(@"星星图析构");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
