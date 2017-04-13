//
//  NewPhoneViewController.m
//  MangroveTree
//
//  Created by sjlh on 2017/3/10.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "NewPhoneViewController.h"

@interface NewPhoneViewController ()<UITextFieldDelegate,MTRequestNetWorkDelegate>
{
    NSString *uuidString;
    int _ukDelay;//倒计时
    NSTimer *_connectionTimer;
}
@property (weak, nonatomic) IBOutlet UITextField *PhoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *validationButton;
@property (weak, nonatomic) IBOutlet UITextField *validationTextField;
@property (weak, nonatomic) IBOutlet UIButton *sumbitButtonAction;
@property (strong, nonatomic) NSURLSessionTask *sendCodeTask;
@property (strong, nonatomic) NSURLSessionTask *changeAccountlTask;
@property (strong, nonatomic) NSURLSessionTask *repeatRegist;

@end

@implementation NewPhoneViewController

@synthesize uuid;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _PhoneTextField.delegate = self;
    _validationTextField.delegate = self;
    
    //设置按钮样式
    [_validationButton ukeyStyle];
    [_sumbitButtonAction loginStyle];
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

#pragma mark - 用户操作

// 开始倒计时
-(void)startTimer
{
    _ukDelay = 60;
    _connectionTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

// 显示验证按钮 or 显示倒计时
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
        [_validationButton setTitle:@"验证码" forState:UIControlStateNormal];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}


#pragma mark - 网络请求

// 绑定新的手机
- (void)bindingNewAccount
{
    if (_validationTextField.text.length != 6)
    {
        [MyAlertView showAlert:@"请输入正确验证码"];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    if (![Util isMobileNumber:_PhoneTextField.text])
    {
        [MyAlertView showAlert:@"请输入正确的手机号"];
        return;
    }
    [params setObject:@"1" forKey:@"bindingType"];
    [params setObject:[[DataManager defaultInstance] findUserLogInByCode:@"1"].password forKey:@"password"];
    NSDictionary *newBinding = @{@"targ":_PhoneTextField.text,
                                 @"code":_validationTextField.text,
                                 @"uuid":[self getUUID]};
    if (self.newAccount == YES)//修改帐号，需要原来的账号信息
    {
        NSDictionary *oldBinding = @{@"targ":self.account,
                                     @"code":self.code,
                                     @"uuid":self.uuid};
        [params setObject:newBinding forKey:@"newBindingInfo"];
        [params setObject:oldBinding forKey:@"oldBindingInfo"];
    }
    else if (self.newAccount == NO)
    {
        [params setObject:newBinding forKey:@"newBindingInfo"];
    }
    self.changeAccountlTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL webURL:@URI_REBIND params:params withByUser:YES andOldInterfaces:YES];
}

// 发送验证码
- (IBAction)validationButtonAction:(id)sender
{
    //在发送验证码之前，先判断用户是否已经注册过
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    [params setObject:_PhoneTextField.text forKey:@"account"];
    if (![Util isMobileNumber:_PhoneTextField.text]) {
        
        [MyAlertView showAlert:@"请输入正确的手机号"];
        return;
    }
    self.repeatRegist = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL webURL:@URI_REPEATREGIST params:params withByUser:YES andOldInterfaces:YES];
}

#pragma mark - 网络请求返回结果代理
- (void)startRequest:(NSURLSessionTask *)task
{
}

- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.repeatRegist)
    {
        //该手机号，用户已经注册过
        if ([datas[0] isEqualToString:@"1"])
        {
            [MyAlertView showAlert:@"此手机号已注册，请重新输入"];
        }
        else
        {
            if ([self.isPhoneOrEmail isEqualToString:@"0"])//手机
            {
                if (![Util isMobileNumber:_PhoneTextField.text])
                {
                    [MyAlertView showAlert:@"请输入正确的手机号"];
                    return;
                }
            }
            NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
            [params setObject:_PhoneTextField.text forKey:@"account"];
            [params setObject:@"3" forKey:@"logicFlag"];
            [params setObject:[self getUUID] forKey:@"uuid"];
            self.sendCodeTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                            webURL:@URI_GETUKEY
                                                                            params:params
                                                                        withByUser:YES
                                                                  andOldInterfaces:YES];
        }
    }
    //发送验证码
    if (task == self.sendCodeTask)
    {
        //开始倒计时
        [self startTimer];
    }
    else if (task == self.changeAccountlTask)
    {//修改成功
        DBUserLogin *userLogin = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
        userLogin.account = _PhoneTextField.text;
        userLogin.mobile = _PhoneTextField.text;
        [[DataManager defaultInstance] saveContext];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiChangeStatusBar object:@"1"];
        [self.navigationController.navigationBar setBackgroundImage:[Util createImageWithColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:17],
           NSForegroundColorAttributeName:[UIColor blackColor]}];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if (task == self.sendCodeTask || task == self.repeatRegist)
    {
        msg = msg.length > 30 ? @"获取验证码失败，请重新尝试" : msg;
        [MyAlertView showAlert:msg];
    }
    if (task == self.changeAccountlTask)
    {
        msg = msg.length > 30 ? @"验证码校验失败，请重新申请验证码" : msg;
        [MyAlertView showAlert:msg];
    }
}

// 保存
- (IBAction)sumbitButtonAction:(id)sender
{
    NSLog(@"保存");
    [self bindingNewAccount];
}

#pragma mark - Private functions

// 点击next将下一个textField处于编辑状态
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_PhoneTextField]){
        [_PhoneTextField resignFirstResponder];
        [_validationTextField becomeFirstResponder];
    }
    return YES;
}

// 获取UUID
- (NSString *)getUUID
{
    if (uuid)
    {
        return uuid;
    }
    else
    {
        CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
        CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
        
        CFRelease(uuid_ref);
        uuid = [NSString stringWithString:(NSString*)CFBridgingRelease(uuid_string_ref)];
        
        return uuid;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
