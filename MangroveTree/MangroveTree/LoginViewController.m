//
//  LoginViewController.m
//  mgmanager
//
//  Created by 苏智 on 15/4/23.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetpawViewController.h"
#import "RegistViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,MTRequestNetWorkDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *visibleImage;

@property (strong, nonatomic) NSURLSessionTask *loginTask;
@property (strong, nonatomic) NSURLSessionTask *getMemberInfor;
@property (strong, nonatomic) NSURLSessionTask *isRegist;

@property (nonatomic, assign) BOOL isVisible;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _accountTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    self.isVisible = NO;
    
//    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"backBtn_white"];
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"backBtn_white"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[Util createImageWithColor:[UIColor colorWithRed:237 / 255.0f green:130 / 255.0f blue:86 / 255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
    
    self.phoneUUIDDictionary = [NSMutableDictionary dictionary];
    self.registUUIDDictionary = [NSMutableDictionary dictionary];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChoose:)];
    [self.visibleImage addGestureRecognizer:tap1];
    
    //设置按钮样式
    [_logInButton loginStyle];
    
    _passwordTextField.delegate = self;
    
    //收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];

    // 调用登录窗体前设置为注册模式，则自动触发导航到注册窗口
    if (self.toRegist == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"sceneRegist"];
        [self.navigationController pushViewController:vc animated:NO];
    }
}
// 网络请求注册代理
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MTRequestNetwork defaultManager]registerDelegate:self];
}

// 网络请求注销代理
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[MTRequestNetwork defaultManager] removeDelegate:self];
}
- (void)dealloc
{
    [[MTRequestNetwork defaultManager] cancleAllRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 用户操作

- (IBAction)selectSegment:(id)sender
{
    UISegmentedControl *sc = (UISegmentedControl *)sender;
    if (sc.selectedSegmentIndex != 0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        RegistViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"sceneRegist"];
        vc.loginController = self;
        [self.navigationController pushViewController:vc animated:NO];
        sc.selectedSegmentIndex = 0;
    }
}

// 点击当前视图收起键盘
- (void)tapAction
{
    [self.view endEditing:YES];
}

- (void)tapChoose:(UITapGestureRecognizer *)tap
{
    if (self.isVisible == YES)
    {
        self.isVisible = NO;
        self.visibleImage.image = [UIImage imageNamed:@"invisibleImage"];
        self.passwordTextField.secureTextEntry = YES;
    }
    else
    {
        self.isVisible = YES;
        self.visibleImage.image = [UIImage imageNamed:@"visibleImage"];
        self.passwordTextField.secureTextEntry = NO;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 66;
    }
    else if (section == 1)
    {
        return 42;
    }
    else if (section == 2)
    {
        return 60;
    }
    else
    {
        return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        [MyAlertView showAlert:@"输入内容不能包含特殊字符"];
        return NO;
    }
    return YES;
}

#pragma mark - 网络请求

// 登录请求
- (IBAction)loginButtonAction:(id)sender
{
    //在登录之前，先判断该手机号是否已经注册
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    [params setObject:_accountTextField.text forKey:@"account"];
    if (![Util isMobileNumber:_accountTextField.text])
    {
        [MyAlertView showAlert:@"请输入正确的手机号"];
        return;
    }
    if (_passwordTextField.text.length < 6 ||_passwordTextField.text.length >18)
    {
        [MyAlertView showAlert:@"请输入6-18位的密码"];
        return;
    }
    self.isRegist = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL webURL:@URI_REPEATREGIST params:params withByUser:YES andOldInterfaces:YES];
}
// 请求会员信息
- (void)requestMemberInfo
{
    NSMutableDictionary* temp = [[NSMutableDictionary alloc]init];
    [temp setObject:@"" forKey:@"proceedsPhone"];
    self.getMemberInfor = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                      webURL:@MEMBER_INFO
                                                                      params:temp
                                                                  withByUser:YES
                                                            andOldInterfaces:YES];
    
}

#pragma mark - 网络请求返还结果代理
- (void)startRequest:(NSURLSessionTask *)task
{
}

- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    //判断是否注册
    if (task == self.isRegist)
    {
        if ([datas[0] isEqualToString:@"1"])
        {
            //手机号或者邮箱
            if (![Util isMobileNumber:_accountTextField.text]) {
                
                [MyAlertView showAlert:@"请输入正确的手机号"];
                return;
            }
            
            //密码
            if (_passwordTextField.text.length < 6 ||_passwordTextField.text.length >18) {
                
                [MyAlertView showAlert:@"请输入6-18位的密码"];
                return;
            }
            
            NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
            [params setObject:_accountTextField.text forKey:@"account"];
            [params setObject:_passwordTextField.text forKey:@"password"];
            self.loginTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                         webURL:@URI_LOGIN
                                                                         params:params
                                                                     withByUser:YES
                                                               andOldInterfaces:YES];
        }
        else
        {
            [MyAlertView showAlert:@"该账户未注册,请先注册"];
        }
    }
    //登录成功的接口
    if (task == self.loginTask)
    {
        //存储用户登录数据
        DBUserLogin *userLogin = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
        userLogin.account = _accountTextField.text;
        userLogin.mobile = _accountTextField.text;
        userLogin.password = _passwordTextField.text;
//        [[DataManager defaultInstance] saveContext];
        
        [self requestMemberInfo];
    }
    else if (task == self.getMemberInfor)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiLoadFMMap object:nil];
            //[[NSNotificationCenter defaultCenter] postNotificationName:NotiHaveNewNoti object:nil];
        }];
    }
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if (task == self.loginTask || self.isRegist)
    {
        [[DataManager defaultInstance] cleanCoreDatabyEntityName:@"DBUserLogin"];
        msg = msg.length > 30 ? @"登录失败，请尝试重新登录" : msg;
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (task == self.getMemberInfor)
    {
        msg = msg.length > 30 ? @"获取登录信息失败，请尝试重新登录" : msg;
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Private functions

// 点击next将下一个textField处于编辑状态
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_accountTextField]) {
        [_accountTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    }
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"refind"])
    {
        ForgetpawViewController * viewController = (ForgetpawViewController *)[segue destinationViewController];
        viewController.loginController = self;
    }
}

@end
