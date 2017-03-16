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
@property (assign, nonatomic) BOOL logOutBack;

@end

@implementation SetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置按钮样式
    [self.logoutButton loginStyle];
    self.logOutBack = NO;
    
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
    if (self.logOutBack == NO)
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowSettings object:nil];
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
            if (indexPath.section == 0)
            {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否清除缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                view.tag = 1002;
                [view show];
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
    [MyAlertView showAlert:@"清除缓存成功"];
}

- (IBAction)CompleteButton:(id)sender
{
    UIAlertView *alent = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"是否退出登录？"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是", nil];
    alent.tag = 1001;
    [alent show];
}

#pragma mark - 网络请求

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 1001)
    {
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        self.logoutTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                      webURL:@URI_LOGOUT
                                                                      params:params
                                                                  withByUser:YES
                                                            andOldInterfaces:YES];
    }else if (buttonIndex == 1 && alertView.tag == 1002)
    {
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
    }
}

- (void)startRequest:(NSURLSessionTask *)task
{
}

- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.logoutTask)
    {
        self.logOutBack = YES;
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
