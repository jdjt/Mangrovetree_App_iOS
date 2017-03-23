//
//  NameViewController.m
//  MangroveTree
//
//  Created by sjlh on 2017/3/10.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "NameViewController.h"

@interface NameViewController ()<MTRequestNetWorkDelegate>
{
    DBUserLogin *user;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (strong, nonatomic) NSURLSessionTask *modiftInforTask;
@end

@implementation NameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置按钮样式
    [_nameButton loginStyle];
    user = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 120;
    }
    return 80;
}

- (IBAction)nameButtonAction:(id)sender
{
    [self modifymember];
}

#pragma mark - 网络请求

// 修改姓名
- (void)modifymember
{
    if (_nameTextField.text.length <2)
    {
        [MyAlertView showAlert:@"填写的姓名格式不正确，请重新填写"];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    [params setObject:_nameTextField.text?_nameTextField.text:@"" forKey:@"nickname"];
    self.modiftInforTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                       webURL:@URI_MODIFY_MEMINFO
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
    if (task == self.modiftInforTask) {//修改个人资料
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改姓名成功"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        user.nickname = _nameTextField.text;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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
@end
