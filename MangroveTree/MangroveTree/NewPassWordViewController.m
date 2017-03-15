//
//  NewPassWordViewController.m
//  mgmanager
//
//  Created by 刘超 on 15/5/5.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "NewPassWordViewController.h"
#import "UIButton+Bootstrap.h"

@interface NewPassWordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *acctountLabel;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (strong, nonatomic) NSURLSessionTask *findPassTask;

- (IBAction)completeButtonAction:(id)sender;

@end

@implementation NewPassWordViewController
@synthesize acctount;
@synthesize code;
@synthesize uuid;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //账号
    _acctountLabel.text = acctount;
    _passWordTextField.delegate = self;
    
    //设置按钮样式
    [_completeButton loginStyle];
    
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
- (void)dealloc
{
    [[MTRequestNetwork defaultManager] cancleAllRequest];
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

#pragma mark - 用户点击

//点击视图收起键盘
- (void)tapAction
{
    [self.view endEditing:YES];
}

#pragma mark - 网络请求

//找回密码
- (IBAction)completeButtonAction:(id)sender
{
    if (_passWordTextField.text.length<6||_passWordTextField.text.length>18) {
        [MyAlertView showAlert:@"请输入6-18位的密码"];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:acctount forKey:@"account"];
    [params setObject:code forKey:@"code"];
    [params setObject:uuid forKey:@"uuid"];
    [params setObject:_passWordTextField.text forKey:@"password"];
    
    self.findPassTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL webURL:@URI_FINDPWD params:params withByUser:YES andOldInterfaces:YES];
}

#pragma mark - 网络请求返还结果的代理
- (void)startRequest:(NSURLSessionTask *)task
{
}
- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.findPassTask)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [MyAlertView showAlert:msg];
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

@end
