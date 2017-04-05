//
//  Parser.m
//  MangroveTree
//
//  Created by 罗禹 on 2017/3/7.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "Parser.h"

@implementation Parser

- (NSMutableArray*)parser:(NSString *)ident fromData:(NSData *)dict
{
    NSMutableArray* datas = [[NSMutableArray alloc]init];
    if([ident isEqualToString:@URI_CHECKUKEY])//验证验证码
    {
        datas =  [self parserVerificationCode:dict];
    }
    else if ([ident isEqualToString:@URI_REPEATREGIST])//用户重复注册 
    {
        datas = [self parserRepeatRegist:dict];
    }
    else if ([ident isEqualToString:@URI_LOGIN])//登录
    {
        datas = [self parserLogin:dict];
    }
    else if ([ident isEqualToString:@MEMBER_INFO])//请求会员信息
    {
        datas = [self parserMembers:dict];
    }else if ([ident isEqualToString:URL_ACTIVITY_DETAIL])
    {
       datas = [self parserInfor:dict];
    }
    //存储数据
    [[DataManager defaultInstance] saveContext];
    return datas;
}

#pragma mark - 用户重复注册
- (NSMutableArray *)parserRepeatRegist:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * mdict = (NSMutableDictionary*)dict;
    NSString* result = [mdict objectForKey:@"result"];
    [array addObject:result];
    return array;
}

#pragma mark - 验证码

- (NSMutableArray *)parserVerificationCode:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * mdict = (NSMutableDictionary*)dict;
    NSString* result = [mdict objectForKey:@"result"];
    [array addObject:result];
    return array;
}

#pragma mark - 登录

- (NSMutableArray *)parserLogin:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * mdict = (NSMutableDictionary*)dict;
    DBUserLogin *userLogin = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
    NSString* ticket = [mdict objectForKey:@"ticket"];
    userLogin.ticker = ticket;
    userLogin.isLogIn = @"1";
    
    [array addObject:ticket];
    return array;
}

#pragma mark - 请求会员信息

- (NSMutableArray *)parserMembers:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * mdict = (NSMutableDictionary*)dict;
    DBUserLogin *userLogin = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
    userLogin.membername = [mdict objectForKey:@"memberName"];
    userLogin.nickname = [mdict objectForKey:@"nickname"];
    userLogin.sex = [mdict objectForKey:@"sex"];
    userLogin.mobile = [mdict objectForKey:@"callPhone"];
    userLogin.email = [mdict objectForKey:@"email"];
    userLogin.openBalabce = [mdict objectForKey:@"openBalance"];
    [array addObject:userLogin];
    return array;
}

- (NSMutableArray *)parserInfor:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * mdict = (NSMutableDictionary*)dict;
    InforModel *model = [[InforModel alloc] init];
    model.name = mdict[@"receive"][@"base_info"][@"name"];
    model.abstracts = mdict[@"receive"][@"base_info"][@"abstracts"];
    model.imgurl = mdict[@"receive"][@"base_info"][@"first_image"][@"url"];
    [array addObject:model];
    return array;
}

@end
