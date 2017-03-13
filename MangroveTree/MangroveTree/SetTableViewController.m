//
//  SetTableViewController.m
//  MangroveTree
//
//  Created by sjlh on 2017/3/10.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "SetTableViewController.h"

@interface SetTableViewController ()<MTRequestNetWorkDelegate>
@property (strong, nonatomic) NSURLSessionTask *logoutTask;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置按钮样式
    [self.logoutButton loginStyle];
    
}

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            // 清楚缓存
            NSLog(@"您点击了清除缓存");
            if (indexPath.section == 0) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清除缓存" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    dispatch_async(
                                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                   , ^{
                                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                       NSLog(@"%@", cachPath);
                                       
                                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                                       NSLog(@"files :%lu",(unsigned long)[files count]);
                                       for (NSString *p in files) {
                                           NSError *error;
                                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                                           }
                                       }
                                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
                }];
                [alert addAction:cancelAction];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        if (indexPath.row == 1)
        {
            // 关于红树林导航
            NSLog(@"您点击了关于红树林导航");
        }
    }
    
}

- (void)clearCacheSuccess
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"清除缓存成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)CompleteButton:(id)sender
{
    UIAlertView *alent = [[UIAlertView alloc] initWithTitle:@"退出登录提示"
                                                    message:@"是否退出登录？"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是", nil];
    [alent show];
}

#pragma mark - 网络请求

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        self.logoutTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                      webURL:@URI_LOGOUT
                                                                      params:params
                                                                  withByUser:YES
                                                            andOldInterfaces:YES];
    }
}

- (void)startRequest:(NSURLSessionTask *)task
{
}

- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.logoutTask)
    {
        //注销登录
        [[DataManager defaultInstance] cleanCoreDatabyEntityName:@"DBUserLogin"];
        [self.navigationController popViewControllerAnimated:YES];
        //刷新视图
        [self.tableView reloadData];
    }
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [MyAlertView showAlert:msg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
