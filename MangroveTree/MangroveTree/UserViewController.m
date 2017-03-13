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
#import "ButtonCell.h"
#import "UIButton+Bootstrap.h"

@interface UserViewController ()
@end

@implementation UserViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0.01f;
    else if (section == [self numberOfSectionsInTableView:tableView] - 1)
        return 33.0f;

    return 22.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 最后一个section留底，以免被导航条挡住
    if (section == [self numberOfSectionsInTableView:tableView] - 1)
        return 60.0f;
    return 0.01f;
}

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
        infoCell.userAvator.image = [UIImage imageNamed:@"toUser"];
        if ([self.user.mobile isEqualToString:@""])
            infoCell.userName.text = self.user.email;
        else
            infoCell.userName.text = self.user.mobile;
        infoCell.userLevel.text = @"红树林会员";
        [infoCell.userAvator setImage:[UIImage imageNamed:@"toUser"]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
        return 80.0f;

    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiBackToMain object:indexPath];
}

@end
