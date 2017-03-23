//
//  ModifypawdViewController.m
//  MangroveTree
//
//  Created by sjlh on 2017/3/10.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "ModifypawdViewController.h"
#import "LoginViewController.h"
@interface ModifypawdViewController ()<UITextFieldDelegate,MTRequestNetWorkDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPawdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pawdTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPawdTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) NSURLSessionTask *modifyPassTask;

@end

@implementation ModifypawdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _oldPawdTextField.delegate = self;
    _pawdTextField.delegate = self;
    _againPawdTextField.delegate = self;
    
    //设置按钮样式
    [_submitButton loginStyle];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section)
    {
        case 0:
            return 3;
            break;
            
        default:
            return 1;
            break;
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

//修改密码
- (IBAction)submitButtonAction:(id)sender
{
    if (_oldPawdTextField.text.length<6||_oldPawdTextField.text.length>18||_againPawdTextField.text.length <6||_againPawdTextField.text.length >18||_pawdTextField.text.length <6 ||_pawdTextField.text.length >18 ) {
        
        [MyAlertView showAlert:@"密码格式不正确，请输入6-18位密码"];
        return;
    }
    
    if (![_pawdTextField.text isEqualToString:_againPawdTextField.text]) {//两次输入的密码是否相同
        
        [MyAlertView showAlert:@"新密码输入不相同"];
        
        return;
    }
    
    if ([_againPawdTextField.text isEqualToString:_oldPawdTextField.text]) {//新旧密码相同
        
        [MyAlertView showAlert:@"新密码和原密码相同"];
        
        return;
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    
    [params setObject:_pawdTextField.text forKey:@"newPassword"];
    [params setObject:_oldPawdTextField.text forKey:@"password"];
    self.modifyPassTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                      webURL:@URI_MODIFY_PWD
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
    [MyAlertView showAlert:@"修改登录密码成功"];
    DBUserLogin *logIn = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
    logIn.password = _againPawdTextField.text;
    
    [[DataManager defaultInstance] cleanCoreDatabyEntityName:@"DBUserLogin"];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController *navi = (UINavigationController *) [storyBoard instantiateViewControllerWithIdentifier:@"loginNavi"];
    LoginViewController* loginVC = (LoginViewController*)[navi topViewController];
    loginVC.showStop = NO;
    [self presentViewController:navi animated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.tableView reloadData];
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
    if ([textField isEqual:_oldPawdTextField]) {
        [_oldPawdTextField resignFirstResponder];
        [_pawdTextField becomeFirstResponder];
    }
    else if ([textField isEqual:_pawdTextField]){
        [_pawdTextField resignFirstResponder];
        [_againPawdTextField becomeFirstResponder];
    }
    return YES;
}

@end
