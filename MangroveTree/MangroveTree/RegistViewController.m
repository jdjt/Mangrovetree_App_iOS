//
//  RegistViewController.m
//  mgmanager
//
//  Created by 苏智 on 15/4/23.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "RegistViewController.h"
#import "UIButton+Bootstrap.h"
#import "AgreementViewController.h"

@interface RegistViewController ()<UITextFieldDelegate,MTRequestNetWorkDelegate>
{
    NSString *uuidString;//uuid
    int _ukDelay;//倒计时
    NSTimer *_connectionTimer;//定时器
}

- (IBAction)registeredButtonAction:(id)sender;
- (IBAction)validationButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *VerificationCode;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
@property (weak, nonatomic) IBOutlet UIButton *validationButton;
@property (weak, nonatomic) IBOutlet UIButton *registeredButton;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImage;


@property (strong, nonatomic) NSURLSessionTask *registTask;
@property (strong, nonatomic) NSURLSessionTask *sengCodeTask;
@property (strong, nonatomic) NSURLSessionTask *loginTask;
@property (strong, nonatomic) NSURLSessionTask *getMemberInfor;

@property (nonatomic, assign) BOOL isChooseYES;

@end

@implementation RegistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _phoneNumber.delegate = self;
    _VerificationCode.delegate = self;
    _loginPassword.delegate = self;
    
    self.isChooseYES = YES;
    
    //设置按钮样式
    [_validationButton ukeyStyle];
    [_registeredButton loginStyle];
    
    _loginPassword.delegate = self;

    // 暂时屏蔽左上角取消按钮
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
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

- (IBAction)selectSegment:(id)sender
{
    UISegmentedControl *sc = (UISegmentedControl *)sender;
    if (sc.selectedSegmentIndex != 1)
    {
        [self.navigationController popViewControllerAnimated:NO];
        sc.selectedSegmentIndex = 1;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 78;
            break;
        case 1:
            return 39;
            break;
        case 2:
            return 39;
            break;
        case 3:
            return 14;
            break;
        case 4:
            return 49;
            break;
        default:
            return 0.01f;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1 && indexPath.row == 1) || indexPath.section == 2)
        cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        if (indexPath.row == 0) {
#warning 准备用webview代替
            AgreementViewController *agrVtrl = [[AgreementViewController alloc] initWithNibName:@"AgreementViewController" bundle:nil];
            agrVtrl.type = @"1";
            agrVtrl.titleLabel = @"红树林管家用户协议";
            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:agrVtrl];
            [self presentViewController:navCtrl animated:YES completion:^{
                
            }];
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 1)
        {
            if (self.isChooseYES == YES)
            {
                self.chooseImage.image = [UIImage imageNamed:@"read_N"];
                self.isChooseYES = NO;
            }
            else
            {
                self.chooseImage.image = [UIImage imageNamed:@"read_Y"];
                self.isChooseYES = YES;
            }
        }
    }
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

// 注册按钮
- (IBAction)registeredButtonAction:(id)sender
{
    //手机号或者邮箱
    if (![Util isMobileNumber:_phoneNumber.text]&&![Util isValidateEmail:_phoneNumber.text]) {
        
        [MyAlertView showAlert:@"请输入正确的手机号或邮箱"];
        return;
    }
    
    //验证码
    if (_VerificationCode.text.length != 6) {
        
        [MyAlertView showAlert:@"请输入正确验证码"];
        return;
    }
    
    //密码
    if (_loginPassword.text.length < 6 ||_loginPassword.text.length >18) {
        
        [MyAlertView showAlert:@"请输入6-18位的密码"];
        return;
    }
    
    //协议
    if (self.isChooseYES == NO) {
        
        [MyAlertView showAlert:@"您没有同意我们的用户协议，请阅读并同意后再注册"];
        return;
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    [params setObject:_phoneNumber.text forKey:@"account"];
    [params setObject:_VerificationCode.text forKey:@"code"];
    NSString* uuid = [self getUUID];
    [params setObject:uuid forKey:@"uuid"];
    [params setObject:_loginPassword.text forKey:@"password"];
    
    self.registTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                  webURL:@URI_REGIST
                                                                  params:params
                                                              withByUser:YES
                                                        andOldInterfaces:YES];
    
}

// 发送验证码
- (IBAction)validationButtonAction:(id)sender
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    if (![Util isMobileNumber:_phoneNumber.text]&&![Util isValidateEmail:_phoneNumber.text]) {
        
        [MyAlertView showAlert:@"请输入正确的手机号或邮箱"];
        return;
    }
    
    [params setObject:_phoneNumber.text forKey:@"account"];
    [params setObject:@"1" forKey:@"logicFlag"];
    NSString* uuid = self.loginController.registUUIDDictionary[_phoneNumber.text] ;
    if (uuid == nil || uuid.length <= 0)
        uuid = [self getUUID];
    [params setObject:uuid forKey:@"uuid"];
    [self.loginController.registUUIDDictionary setObject:uuid forKey:_phoneNumber.text];
    self.sengCodeTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                    webURL:@URI_GETUKEY
                                                                    params:params
                                                                withByUser:YES
                                                          andOldInterfaces:YES];
}

//  直接登录
- (void)toLogin
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    [params setObject:self.phoneNumber.text forKey:@"account"];
    [params setObject:self.loginPassword.text forKey:@"password"];
    self.loginTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                 webURL:@URI_LOGIN
                                                                 params:params
                                                             withByUser:YES
                                                       andOldInterfaces:YES];
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
    //发送验证码
    if (task == self.sengCodeTask)
    {
        //开始倒计时
        [self startTimer];
    //注册成功
    }
    else if (task == self.registTask)
    {
        DBUserLogin *userLogin = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
        userLogin.account = self.phoneNumber.text;
        userLogin.mobile = self.phoneNumber.text;
        userLogin.password = self.loginPassword.text;
        [[DataManager defaultInstance]saveContext];
        [self toLogin];
    }
    else if (task == self.loginTask)
    {
        [self requestMemberInfo];
    }
    else if (task == self.getMemberInfor)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if (task == self.loginTask)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"自动登录失败！请用户尝试手动登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [MyAlertView showAlert:msg];
    }
}

#pragma mark - Private functions

// 点击next将下一个textField处于编辑状态
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_phoneNumber]) {
        [_phoneNumber resignFirstResponder];
        [_VerificationCode becomeFirstResponder];
    }
    else if ([textField isEqual:_VerificationCode]){
        [_VerificationCode resignFirstResponder];
        [_loginPassword becomeFirstResponder];
    }
    return YES;
}

// 获取UUID
-(NSString*)getUUID
{
    if (uuidString) {
        return uuidString;
    }
    CFUUIDRef uuid = CFUUIDCreate(nil);
    uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    CFRelease(uuid);
    //	NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    return uuidString;
}

// 开始倒计时
-(void)startTimer
{
    _ukDelay = 60;
    _connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_connectionTimer forMode:NSDefaultRunLoopMode];
}

// 显示验证按钮或显示倒计时
- (void)timerFired
{
    if(_ukDelay>0){
        _ukDelay--;
        _validationButton.enabled = NO;
        NSString* label = [[NSString stringWithFormat:@"%d",_ukDelay]stringByAppendingString:@"秒"];
        [_validationButton setTitle:label forState:UIControlStateNormal];
        
    }else{
        [_connectionTimer invalidate];
        _validationButton.enabled = YES;
        _connectionTimer = nil;
        [_validationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
    
}

@end
