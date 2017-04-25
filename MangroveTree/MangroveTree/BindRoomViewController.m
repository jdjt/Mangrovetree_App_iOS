//
//  BindRoomViewController.m
//  MangroveTree
//
//  Created by liuchao on 2017/4/11.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "BindRoomViewController.h"
#import "FrameViewController.h"

@interface BindRoomViewController ()<MTRequestNetWorkDelegate>

@property (nonatomic, strong) NSURLSessionTask *bingRoomTask;
@property (weak, nonatomic) IBOutlet UITextField *roomCode;
@property (weak, nonatomic) IBOutlet UITextField *idNumber;

@end

@implementation BindRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"绑定客房";
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MTRequestNetwork defaultManager] registerDelegate:self];
}
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
- (void)backToMain:(UIBarButtonItem *)bar
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - NetWork
- (IBAction)bingRoomAction:(id)sender
{
    if (self.roomCode.text.length <= 0 || self.idNumber.text.length < 4)
    {
        [MyAlertView showAlert:@"请输入正确的房间号与省份证号后四位"];
        return;
    }
    [self bingRoomNetWorking];
}

- (void)bingRoomNetWorking
{
    NSDictionary *dic = @{@"hotelCode":@"2",@"roomCode":self.roomCode.text,@"pagersCode":self.idNumber.text,@"deviceId":[Util macaddress],@"deviceToken":[Util deviceToken],@"deviceType":@"2"};
    self.bingRoomTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                    webURL:URL_BINGROOM
                                                                    params:dic
                                                                withByUser:YES
                                                          andOldInterfaces:YES];
}

- (void)startRequest:(NSURLSessionTask *)task
{
    
}

- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.bingRoomTask)
    {
        self.frameController.goChat = YES;
        [self.navigationController popViewControllerAnimated:NO];
    }
}
- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if (task == self.bingRoomTask)
    {
        [MyAlertView showAlert:msg];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
