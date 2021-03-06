//
//  PersonalDataViewController.m
//  MangroveTree
//
//  Created by yadong on 2017/3/10.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "FrameViewController.h"
#import "BaseNavigationController.h"
@interface PersonalDataViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic,strong)BaseNavigationController * baseNC;

@end

@implementation PersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    DBUserLogin *user = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
    self.nameLabel.text = user.nickname;
    //判断是否开通手机
    if (![user.mobile isEqualToString:@""])
    {
        NSString *string=[user.mobile stringByReplacingOccurrencesOfString:[user.mobile substringWithRange:NSMakeRange(3,4)]withString:@"****"];
        _phoneNumberLabel.text = string;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            // 修改姓名
            [self performSegueWithIdentifier:@"toName" sender:nil];
        }
        if (indexPath.row == 1)
        {
            // 绑定手机
            [self performSegueWithIdentifier:@"changePhone" sender:nil];
        }
        else if (indexPath.row == 2)
        {
            //修改登录密码
            [self performSegueWithIdentifier:@"Changepawd" sender:nil];
        }
    }
}


//- (void)back:(UIButton *)btn
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowSettings object:nil];
//    [self.baseNC.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
