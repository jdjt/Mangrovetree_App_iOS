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
#import "UILabel+ChangeLineSpace.h"

@interface BaseAlertViewController () <UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headTitleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTraling;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comfirmWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headTitleTraling;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backGroundLeading;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, copy) NSMutableAttributedString * headTitle;
@property (nonatomic, copy) NSString * detail;
@property (nonatomic, strong) NSArray * buttonTitles;
@property (nonatomic, strong) UIImage * topImage;
@property (nonatomic, assign) CGFloat buttonLeadingContant;
@property (nonatomic, assign) CGFloat buttonTrailingContant;
@property (nonatomic, assign) CGFloat headImageSize;
@property (nonatomic, strong) UIFont * headTitleFont;
@property (nonatomic, strong) UIFont * detailFont;
@property (nonatomic, strong) UIFont * buttonTitleFont;
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL action1;
@property (nonatomic, assign) SEL action2;

@end

@implementation BaseAlertViewController

+ (instancetype)initWithHeadTitle:(NSMutableAttributedString *)headTitle andWithDetail:(NSString *)detail andWithCheckTitles:(NSArray *)checkTitles andWithButtonTitles:(NSArray *)buttonTitles andWithHeadImage:(UIImage *)image
{
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"BaseAlert" bundle:nil];
    BaseAlertViewController * viewController = (BaseAlertViewController *)[story instantiateViewControllerWithIdentifier:@"BaseAlertViewController"];
    if (viewController)
    {
        viewController.transitioningDelegate = viewController;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        viewController.topImage = image;
        viewController.selectTable = NSNotFound;
        viewController.headTitle = headTitle;
        viewController.detail = detail;
        viewController.dataArray = [NSArray arrayWithArray:checkTitles];
        viewController.buttonTitles = buttonTitles;
        [viewController initializeFuncStatus];
    }
    return viewController;
}

// 根据使用类型初始化(使用tableView选择框的)
+ (instancetype)alertWithAlertType:(BaseAlertType)alertType andWithCheckTitles:(NSArray *)checkTitles andWithWaiterId:(NSString *)waiterId
{
    BaseAlertViewController * alert = nil;
    switch (alertType)
    {
        case AlertType_systemAutoCancelTask:
        {
            alert = [BaseAlertViewController initWithHeadTitle:nil andWithDetail:@"" andWithCheckTitles:checkTitles andWithButtonTitles:@[@"确 认"] andWithHeadImage:nil];
        }
            break;
        case AlertType_callTaskComplete:
        {
            NSString * head = @"服务员：";
            NSMutableAttributedString * title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",head,waiterId]];
            [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255 / 255.0 green:128 / 255.0 blue:75 / 255.0 alpha:1] range:NSMakeRange(head.length,waiterId.length)];
            alert = [BaseAlertViewController initWithHeadTitle:title andWithDetail:@"您的呼叫服务已完成，请您确认，谢谢配合！" andWithCheckTitles:checkTitles andWithButtonTitles:@[@"未完成",@"已完成"] andWithHeadImage:nil];
        }
            break;
        case AlertType_cancelTaskReason:
        {
            alert = [BaseAlertViewController initWithHeadTitle:[[NSMutableAttributedString alloc]initWithString:@"选择取消呼叫服务原因："] andWithDetail:nil andWithCheckTitles:checkTitles andWithButtonTitles:@[@"呼叫继续",@"放弃呼叫"] andWithHeadImage:nil];
            [alert setTitleTextAlignment:NSTextAlignmentLeft];
        }
            break;
        case AlertType_waiterOrderReceiving:
        {
            alert = [BaseAlertViewController initWithHeadTitle:nil andWithDetail:[NSString stringWithFormat:@"您好，我是服务员%@，很高兴为您服务！",waiterId] andWithCheckTitles:checkTitles andWithButtonTitles:@[@"确 认"] andWithHeadImage:nil];
        }
            break;
        default:
        {
            alert = [BaseAlertViewController initWithHeadTitle:[[NSMutableAttributedString alloc]initWithString:@"系统提示"] andWithDetail:nil andWithCheckTitles:checkTitles andWithButtonTitles:@[@"确 认"] andWithHeadImage:nil];
        }
            break;
    }
    return alert;
}

// 根据使用类型初始化
+ (instancetype)alertWithAlertType:(BaseAlertType)alertType andWithWaiterId:(NSString *)waiterId
{
    return [BaseAlertViewController alertWithAlertType:alertType andWithCheckTitles:nil andWithWaiterId:waiterId];
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
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    self.backGroundView.clipsToBounds = YES;
    self.backGroundView.layer.cornerRadius = 7.0f;
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
    
    // headImage
    self.imageTop.constant = self.topImage == nil ? 0 : 30;
    self.imageHeight.constant = self.topImage == nil ? 0 : (self.headImageSize > 0 ? self.headImageSize : 80);
    self.headImage.image = self.topImage == nil ? nil : self.topImage;
    
    // headTitle
    self.headTitleTop.constant = self.headTitle.length > 0 ? (self.detail.length > 0 ? 25 : 24) : 0;
    self.headTitleHeight.constant = self.headTitleFont.lineHeight;
    self.titleLabel.textAlignment = self.titleTextAlignment;
    self.titleLabel.attributedText = self.headTitle;
    
    // detail
    CGFloat lineSpace = self.headTitle.length > 0 ? 11 : 18;
    self.detailTop.constant = self.detail.length > 0 ? (self.headTitle.length > 0 ? 25 : 32) : 0;
    CGSize detailSize = self.detail.length > 0 ? [self.detail sizeWithAttributes: @{NSFontAttributeName:self.detailFont}] : CGSizeMake(0, 0);
    NSInteger lines = ceilf(detailSize.width / (kScreenWidth - 2 * (self.backGroundLeading.constant + self.detailTraling.constant)));
    self.detailHeight.constant =  lines > 1 ? (lines * (1 + lineSpace + self.detailFont.lineHeight) - lineSpace) : (lines == 1 ? (self.detailFont.lineHeight + 1) : 0);
    self.detailLabel.text = self.detail;
    if (self.detail.length > 0)
        [UILabel changeLineSpaceForLabel:self.detailLabel WithSpace:lineSpace];
    
    // tableView
    self.tableViewHeight.constant = self.dataArray.count > 0 ? 18 : 0;
    
    // buttonTop
    self.buttonTop.constant = self.dataArray.count > 0 ? 11 : 32;
    
    self.alertHeight.constant = self.imageTop.constant + self.imageHeight.constant + self.headTitleTop.constant + self.headTitleHeight.constant + self.detailTop.constant + self.detailHeight.constant + self.tableViewHeight.constant + (45 * self.dataArray.count + (self.dataArray.count > 0 ? 0.5 : 0)) + self.buttonTop.constant + self.buttonHeight.constant;
    
    self.headImage.image = self.topImage == nil ? nil : self.topImage;
    if (self.buttonTitles.count == 1)
    {
        [self.comfirmButton setTitle:self.buttonTitles[0] forState:UIControlStateNormal];
        self.cancelButton.hidden = YES;
        self.comfirmWidth.constant = self.backGroundView.frame.size.width * 0.5;
    }
    else if (self.buttonTitles.count > 1)
    {
        [self.cancelButton setTitle:self.buttonTitles[0] forState:UIControlStateNormal];
        [self.comfirmButton setTitle:self.buttonTitles[1] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

#pragma mark - constraint func model


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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count > 0 ? 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertViewCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"alertCenter"];
    cell.chooseImage.image = self.selectTable == indexPath.row ? [UIImage imageNamed:@"AlertSelectImage_Yes"] : [UIImage imageNamed:@"AlertSelectImage_No"];
    cell.chooseTitle.text = self.dataArray[indexPath.row];
    if (indexPath.row == self.dataArray.count - 1)
        cell.bottomLine.hidden = YES;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width,0.5f)];
    view.backgroundColor = [UIColor colorWithRed:97 / 255.0f green:97 / 255.0f blue:97 / 255.0f alpha:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}

#pragma mark - 公开方法

- (void)setHeadImageSizes:(CGFloat)height
{
    self.headImageSize = height;
}

- (void)setHeadTitleFont:(UIFont *)headTitleFont andDetailFont:(UIFont *)detailFont andWithButtonTitleFont:(UIFont *)buttonTitleFont
{
    self.headTitleFont = headTitleFont;
    self.detailFont = detailFont;
    self.buttonTitleFont = buttonTitleFont;
}

- (void)setWordFont
{
    if (self.headTitleFont != nil)
        self.titleLabel.font = self.headTitleFont;
    if (self.detailFont != nil)
        self.detailLabel.font = self.detailFont;
    if (self.buttonTitleFont != nil)
    {
        self.cancelButton.titleLabel.font = self.buttonTitleFont;
        self.comfirmButton.titleLabel.font = self.buttonTitleFont;
    }
}

- (void)setHeadTitleTextAlignment:(NSTextAlignment)textAlignment
{
    self.titleTextAlignment = textAlignment;
}

- (void)initializeFuncStatus
{
    self.headImageSize = 0;
    self.headTitleFont = [UIFont systemFontOfSize:19];
    self.detailFont = [UIFont systemFontOfSize:19];
    self.buttonTitleFont = nil;
    self.titleTextAlignment = NSTextAlignmentCenter;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    AlertPresentAnimation * animation = [[AlertPresentAnimation alloc] init];
    return animation;
}

@end
