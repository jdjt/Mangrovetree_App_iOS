//
//  ChangePhoneViewController.m
//  MangroveTree
//
//  Created by sjlh on 2017/3/10.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "NewPhoneViewController.h"

@interface ChangePhoneViewController ()<MTRequestNetWorkDelegate>
{
    NSString *uuidString;
    int _ukDelay;//倒计时
    NSTimer *_connectionTimer;
    DBUserLogin *user;
}
@property (weak, nonatomic) IBOutlet UILabel *acctountLabel;
@property (weak, nonatomic) IBOutlet UIButton *validationButton;
@property (weak, nonatomic) IBOutlet UITextField *validationTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) NSURLSessionTask *sengCodeTask;
@property (nonatomic, strong) NSURLSessionTask *checkCodeTask;


@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置按钮样式
    [_validationButton ukeyStyle];
//    [_validationButton setTitleColor:[UIColor colorWithRed:122/255.0f green:177/255.0f blue:147/255.0f alpha:1] forState:UIControlStateNormal];
    [_nextButton loginStyle];
    user = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
    if ([user.mobile isEqualToString:@""])
        [self performSegueWithIdentifier:@"newPhone" sender:nil];
    else
        _acctountLabel.text = user.mobile;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

// 发送验证码
- (IBAction)validationButtonAction:(id)sender
{
    NSLog(@"发送验证码");
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [params setObject:_acctountLabel.text forKey:@"account"];
    
    [params setObject:@"3" forKey:@"logicFlag"];
    NSString* uuid = [self getUUID];
    
    [params setObject:uuid forKey:@"uuid"];
    self.sengCodeTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                    webURL:@URI_GETUKEY
                                                                    params:params
                                                                withByUser:YES
                                                          andOldInterfaces:YES];
}

//验证 验证码
- (IBAction)nextButtonAction:(id)sender
{
    if ([_validationTextField.text isEqualToString:@""]||_validationTextField.text.length !=6)
    {
        [MyAlertView showAlert:@"请输入正确的验证码"];
        return;
    }
    
    NSString* uuid = [self getUUID];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    
    [params setObject:_validationTextField.text forKey:@"code"];
    [params setObject: uuid forKey:@"uuid"];
    
    self.checkCodeTask =  [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL webURL:@URI_CHECKUKEY params:params withByUser:YES andOldInterfaces:YES];
}

#pragma mark - 网络请求返回结果代理
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
    }
    //验证成功
    else if (task == self.checkCodeTask)
    {
        NSString* result = [datas objectAtIndex:0];
        if ([result isEqualToString:@"0"])
        {
            [self performSegueWithIdentifier:@"newPhone" sender:nil];
        }
        else
        {
            [MyAlertView showAlert:@"验证码错误"];
        }
    }
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    [MyAlertView showAlert:msg];
}

#pragma mark - Private functions

// 倒计时开始
-(void)startTimer
{
    _ukDelay = 60;
    _connectionTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_connectionTimer forMode:NSDefaultRunLoopMode];
}

// 是否隐藏验证码显示倒计时
- (void)timerFired
{
    if(_ukDelay>0)
    {
        _ukDelay--;
        _validationButton.enabled = NO;
        NSString* label = [[NSString stringWithFormat:@"%d",_ukDelay]stringByAppendingString:@"秒"];
        [_validationButton setTitle:label forState:UIControlStateNormal];
        
    }
    else
    {
        [_connectionTimer invalidate];
        _validationButton.enabled = YES;
        _connectionTimer = nil;
        [_validationButton setTitle:@"验证码" forState:UIControlStateNormal];
    }
    
}

// 获取UUID
-(NSString*)getUUID
{
    if (uuidString)
    {
        return uuidString;
    }
    CFUUIDRef uuid = CFUUIDCreate(nil);
    uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    CFRelease(uuid);
    return uuidString;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NewPhoneViewController *newPhoneController = (NewPhoneViewController *)segue.destinationViewController;
    newPhoneController.uuid = uuidString;
    newPhoneController.code = _validationTextField.text;
    newPhoneController.account = _acctountLabel.text;
    if ([segue.identifier isEqualToString:@"newPhone"])//修改新手机
    {
        newPhoneController.newAccount = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
