//
//  UserViewController.m
//  mgmanager
//
//  Created by 苏智 on 15/4/20.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "UserViewController.h"
#import "AppDelegate.h"
#import "UserInfoCell.h"
#import "UserCell.h"
#import "UIButton+Bootstrap.h"

@interface UserViewController ()
@end

@implementation UserViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[Util createImageWithColor:[UIColor colorWithRed:237 / 255.0f green:130 / 255.0f blue:86 / 255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
    self.user = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setSelectedLocationName:(NSString *)selectedLocationName
{
    if ([_selectedLocationName isEqualToString:selectedLocationName])
        return;
    _selectedLocationName = selectedLocationName;
    [self.tableView reloadData];
}

#pragma mark - 用户操作

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

//头间距高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0.01f;
    else if (section == [self numberOfSectionsInTableView:tableView] - 1)
        return kScreenHeight - 116 - 49 - 26;

    return 22.0f;
}

//脚间距高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 最后一个section留底，以免被导航条挡住
    if (section == [self numberOfSectionsInTableView:tableView] - 1)
        return 26.0f;
    return 0.01f;
}

//每个分区有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        UserInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
        infoCell.userAvator.image = [UIImage imageNamed:@"memberImage"];
        if ([self.user.mobile isEqualToString:@""])
            infoCell.userName.text = self.user.email;
        else
            infoCell.userName.text = self.user.mobile;
        infoCell.userLevel.text = @"红树林会员";
        cell = infoCell;
    }
    else if (indexPath.section == 1)
    {
        UserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
        userCell.titleLabel.text = @"设置";
        [userCell.naviIconImage setImage:[UIImage imageNamed:@"SetImage"]];
        cell = userCell;
    }
     return cell;
}

#pragma mark - Table view delegate
//头内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
        return 116.0f;

    return 49.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiBackToMain object:indexPath];
}

@end
