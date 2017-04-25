//
//  DataManager+User.m
//  mgmanager
//
//  Created by 苏智 on 15/6/25.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "DataManager+User.h"

@implementation DataManager (User)

// 判断是否登录
- (BOOL)findUserLogIn
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLogIn = %@", @"1"];
    NSArray *result = [self arrayFromCoreData:@"DBUserLogin" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
    if (result.count <= 0 || result == nil)
        return NO;
    else
        return YES;
}
// 查找本地是否有个人信息
- (BOOL)findLocationUserPersonalInformation
{
    DBUserLogin *login = [self findUserLogInByCode:@"1"];
    if (login.membername != nil &&![login.membername isEqualToString:@""])
    {
        return YES;
    }
    return NO;
}
// 查找登录信息
- (DBUserLogin *)findUserLogInByCode:(NSString *)isLogIn
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLogIn = %@", isLogIn];
    NSArray *result = [self arrayFromCoreData:@"DBUserLogin" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
    if (result.count <= 0 ||result == nil)
        return (DBUserLogin *)[self insertIntoCoreData:@"DBUserLogin"];
    return result[0];
}

// 获取参数表
- (DBParameter *)getParameter
{
    DBParameter *parameter = nil;
    NSArray *result = [self arrayFromCoreData:@"DBParameter" predicate:nil limit:NSIntegerMax offset:0 orderBy:nil];
    if (result.count<= 0 || result == nil)
    {
        parameter = (DBParameter *)[self insertIntoCoreData:@"DBParameter"];
        parameter.diviceId = @"";
        parameter.deviceToken = @"";
    }
    else
        parameter = result[0];
    return parameter;
}

- (DBBindCustom *)getCustomerBingRoom
{
    DBBindCustom *custombind = nil;
    NSArray *result = [self arrayFromCoreData:@"DBBindCustom" predicate:nil limit:NSIntegerMax offset:0 orderBy:nil];
    if (result.count <= 0 || result == nil)
    {
        custombind = (DBBindCustom *)[self insertIntoCoreData:@"DBBindCustom"];
    }else
    {
        custombind = result[0];
    }
    return custombind;
}

@end
