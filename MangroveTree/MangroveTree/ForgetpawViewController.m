//
//  ForgetpawViewController.m
//  mgmanager
//
//  Created by 刘超 on 15/5/5.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "ForgetpawViewController.h"
#import "UIButton+Bootstrap.h"

@interface ForgetpawViewController () <UITextFieldDelegate,MTRequestNetWorkDelegate>

{
    NSString *uuidString;
    int _ukDelay;//倒计时
    NSTimer *_connectionTimer;
}
@property (nonatomic, strong) NSURLSessionTask *sendCodeTask;
@property (nonatomic, strong) NSURLSessionTask *checkCodeTask;

@property (weak, nonatomic) IBOutlet UITextField *accounttextfield;
@property (weak, nonatomic) IBOutlet UITextField *verificationTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;

- (IBAction)verificationButton:(id)sender;
- (IBAction)nextButtonAction:(id)sender;

@end

@implementation ForgetpawViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _accounttextfield.delegate = self;
    _verificationTextfield.delegate = self;
    
    //设置按钮样式
    [_verificationButton ukeyStyle];
    [_nextButton loginStyle];
    
    _accounttextfield.delegate = self;
    
    //收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

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
    else
    {
        return 60;
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

#pragma mark - 用户操作

// 点击视图收起键盘
- (void)tapAction
{
    [self.view endEditing:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"newPassWord"]) {
        UITableViewController *vc = segue.destinationViewController;
        [vc setValue:_accounttextfield.text forKey:@"acctount"];
        [vc setValue:_verificationTextfield.text forKey:@"code"];
        [vc setValue:uuidString forKey:@"uuid"];

    }
}

#pragma mark - 网络请求

// 发送验证码
- (IBAction)verificationButton:(id)sender
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    NSString* acc = _accounttextfield.text;
    if (![Util isMobileNumber:acc]&&![Util isValidateEmail:acc]) {
        [MyAlertView showAlert:@"请输入正确的账号后再验证"];
        return;
    }
    [params setObject:acc forKey:@"account"];
    [params setObject:@"2" forKey:@"logicFlag"];
    NSString* uuid = [self getUUID];
    [params setObject:uuid forKey:@"uuid"];
    [self.loginController.phoneUUIDDictionary setObject:uuid forKey:acc];
    self.sendCodeTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_SCREAT
                                                                    webURL:@URI_GETUKEY
                                                                    params:params
                                                                withByUser:YES
                                                          andOldInterfaces:YES];
}

//验证验证码
- (IBAction)nextButtonAction:(id)sender
{
    //手机号或者邮箱
    if (![Util isMobileNumber:_accounttextfield.text]&&![Util isValidateEmail:_accounttextfield.text]) {
        
        [MyAlertView showAlert:@"请输入正确的手机号或邮箱"];
        return;
    }
    
    //验证码
    if (_verificationTextfield.text.length != 6) {
        
        [MyAlertView showAlert:@"请输入正确验证码"];
        return;
    }
    
    NSString* uuid = self.loginController.phoneUUIDDictionary[_accounttextfield.text] ;
    if (uuid == nil || uuid.length <= 0)
        uuid = [self getUUID];
    NSDictionary *dic = @{@"code":_verificationTextfield.text,@"uuid":uuid};
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dic];
    self.checkCodeTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                     webURL:@URI_CHECKUKEY
                                                                     params:params
                                                                 withByUser:YES
                                                           andOldInterfaces:YES];
}

#pragma mark - 网络请求返回结果代理
- (void)startRequest:(NSURLSessionTask *)task
{
}

- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    //发送验证码
    if (task == self.sendCodeTask)
    {
        //开始倒计时
        [self startTimer];
        //验证验证码成功
    }
    else if (task == self.checkCodeTask)
    {
        NSString* result = [datas objectAtIndex:0];
        if ([result isEqualToString:@"0"])
        {
            [self performSegueWithIdentifier:@"newPassWord" sender:nil];
        }
        else
        {
            [MyAlertView showAlert:@"验证码错误"];
        }
    }
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if ([code isEqualToString:@"-1009"])
    {
        [MyAlertView showAlert:@"没有网络，操作失败!"];
        return;
    }
    [MyAlertView showAlert:msg];
}

#pragma mark - Private functions

// 点击next将下一个textField处于编辑状态
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_accounttextfield]) {
        [_accounttextfield resignFirstResponder];
        [_verificationTextfield becomeFirstResponder];
    }
    return YES;
}

// 开始倒计时
-(void)startTimer
{
    _ukDelay = 60;
    _connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

// 显示倒计时或验证码按钮
- (void)timerFired
{
    if(_ukDelay>0)
    {
        _ukDelay--;
        _verificationButton.enabled = NO;
        NSString* label = [[NSString stringWithFormat:@"%d",_ukDelay]stringByAppendingString:@"秒"];
        [_verificationButton setTitle:label forState:UIControlStateNormal];
        
    }
    else
    {
        _verificationButton.enabled = YES;
        [_connectionTimer invalidate];
        _connectionTimer = nil;
        [_verificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
    
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

@end
