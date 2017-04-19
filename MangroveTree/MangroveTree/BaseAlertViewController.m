//
//  BaseAlertViewController.m
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/4/11.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "BaseAlertViewController.h"
#import "AlertViewCenterCell.h"
#import "AlertPresentAnimation.h"

@interface BaseAlertViewController () <UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comfirmWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTrailing;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) UIView * backView;

@property (nonatomic, copy) NSString * headTitle;
@property (nonatomic, strong) NSArray * buttonTitles;
@property (nonatomic, strong) UIImage * topImage;
@property (nonatomic, assign) CGFloat buttonLeadingContant;
@property (nonatomic, assign) CGFloat buttonTrailingContant;
@property (nonatomic, assign) CGFloat headImageSize;
@property (nonatomic, strong) UIFont * headTitleFont;
@property (nonatomic, strong) UIFont * buttonTitleFont;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL action1;
@property (nonatomic, assign) SEL action2;

// will view 中方法控制
@property (nonatomic, assign) BOOL isSetButtonContant;

@end

@implementation BaseAlertViewController

+ (instancetype)initWithHeadTitle:(NSString *)headTitle andWithCheckTitles:(NSArray *)checkTitles andWithButtonTitles:(NSArray *)buttonTitles andWithHeadImage:(UIImage *)image
{
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"BaseAlert" bundle:nil];
    BaseAlertViewController * viewController = (BaseAlertViewController *)[story instantiateViewControllerWithIdentifier:@"BaseAlertViewController"];
    if (viewController)
    {
        viewController.transitioningDelegate = viewController;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        viewController.backView = viewController.backGroundView;
        viewController.topImage = image;
        viewController.selectTable = NSNotFound;
        viewController.headTitle = headTitle;
        viewController.dataArray = [NSArray arrayWithArray:checkTitles];
        viewController.buttonTitles = buttonTitles;
        [viewController initializeFuncStatus];
    }
    return viewController;
}

- (NSArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self addButtonAction];
    self.view.clipsToBounds = NO;
    [self setWordFont];
    
    self.imageHeight.constant = self.topImage == nil ? 0 : (self.headImageSize > 0 ? self.headImageSize : 80);
    self.headImage.image = self.topImage == nil ? nil : self.topImage;
    
    CGSize size = [self.headTitle boundingRectWithSize:CGSizeMake(self.titleLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.headTitleFont} context:nil].size;
    self.headTitleHeight.constant = size.height;
    self.alertHeight.constant = 20 + self.imageHeight.constant + 10 + self.headTitleHeight.constant + 10 + 30 * self.dataArray.count + 10 + 30 + 8;
    
    self.titleLabel.text = self.headTitle;
    if (self.buttonTitles.count == 1)
    {
        [self.comfirmButton setTitle:self.buttonTitles[0] forState:UIControlStateNormal];
        self.cancelButton.hidden = YES;
        self.comfirmWidth.constant = self.backGroundView.frame.size.width * 3 / 5 - self.buttonLeading.constant - self.buttonTrailing.constant;
    }
    else if (self.buttonTitles.count > 1)
    {
        [self.cancelButton setTitle:self.buttonTitles[0] forState:UIControlStateNormal];
        [self.comfirmButton setTitle:self.buttonTitles[1] forState:UIControlStateNormal];
    }
    self.cancelButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.cancelButton.layer.borderWidth = 1.0f;
    self.cancelButton.layer.cornerRadius = 5.0f;
    self.comfirmButton.layer.borderColor = [UIColor colorWithRed:237 / 255.0f green:130 / 255.0f blue:86 / 255.0f alpha:1].CGColor;
    self.comfirmButton.layer.borderWidth = 1.0f;
    self.comfirmButton.layer.cornerRadius = 5.0f;
    
    self.backGroundView.layer.cornerRadius = 10.0f;
    [self.tableView reloadData];
    
    if (self.isSetButtonContant == YES)
        [self settingButtonContant];
}

#pragma mark - action

- (void)addTarget:(id)target andWithComfirmAction:(SEL)action
{
    self.target = target;
    self.action1 = action;
}

- (void)addTarget:(id)target andWithComfirmAction:(SEL)action1 andWithCancelAction:(SEL)action2
{
    self.target = target;
    self.action1 = action1;
    self.action2 = action2;
}

- (void)addButtonAction
{
    [self.comfirmButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back:(UIButton *)sender
{
    if (!self.target)
        return;
    if (self.dataArray.count > 0 && self.selectTable == NSNotFound)
    {
        [MyAlertView showAlert:@"请选择取消原因"];
        return;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
    if (sender == self.comfirmButton)
    {
        if ([self.target respondsToSelector:self.action1])
        {
            [self.target performSelector:self.action1 withObject:self afterDelay:0.0];
        }
    }
    else if (sender == self.cancelButton)
    {
        if ([self.target respondsToSelector:self.action2])
        {
            [self.target performSelector:self.action2 withObject:self afterDelay:0.0];
        }
    }
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertViewCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"alertCenter"];
    cell.chooseImage.image = self.selectTable == indexPath.row ? [UIImage imageNamed:@"read_Y"] : [UIImage imageNamed:@"read_N"];
    cell.chooseTitle.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * set = [NSMutableArray array];
    if (self.selectTable == NSNotFound)
    {
        self.selectTable = indexPath.row;
        [set addObject:indexPath];
    }
    else if (self.selectTable == indexPath.row)
    {
        self.selectTable = NSNotFound;
        [set addObject:indexPath];
    }
    else
    {
        [set addObject:[NSIndexPath indexPathForRow:self.selectTable inSection:0]];
        [set addObject:indexPath];
        self.selectTable = indexPath.row;
    }
    [self.tableView reloadRowsAtIndexPaths:set withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 公开方法

- (void)setButtonLeadingTrailingContants:(CGFloat)contant
{
    self.isSetButtonContant = YES;
    self.buttonTrailingContant = contant;
    self.buttonLeadingContant = contant;
}

- (void)setHeadImageSizes:(CGFloat)height
{
    self.headImageSize = height;
}

- (void)setHeadTitleFont:(UIFont *)headTitleFont andWithButtonTitleFont:(UIFont *)buttonTitleFont
{
    self.headTitleFont = headTitleFont;
    self.buttonTitleFont = buttonTitleFont;
}

- (void)setWordFont
{
    if (self.headTitleFont != nil)
        self.titleLabel.font = self.headTitleFont;
    if (self.buttonTitleFont != nil)
    {
        self.cancelButton.titleLabel.font = self.buttonTitleFont;
        self.comfirmButton.titleLabel.font = self.buttonTitleFont;
    }
}

- (void)settingButtonContant
{
    self.buttonLeading.constant = self.buttonLeadingContant;
    self.buttonTrailing.constant = self.buttonTrailingContant;
}

- (void)initializeFuncStatus
{
    self.isSetButtonContant = NO;
    self.headImageSize = 0;
    self.headTitleFont = [UIFont systemFontOfSize:15];
    self.buttonTitleFont = nil;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    AlertPresentAnimation * animation = [[AlertPresentAnimation alloc] init];
    return animation;
}

@end
