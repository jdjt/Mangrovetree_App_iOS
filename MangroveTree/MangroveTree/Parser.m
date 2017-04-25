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
    }else if ([ident isEqualToString:URL_CHECKBINDROOM])// 检查是否绑定客房
    {
        datas = [self parserCheckBingRoom:dict];
    }else if ([ident isEqualToString:URL_BINGROOM])// 绑定客房
    {
        datas = [self parserBindRoom:dict];
    }
    //存储数据
    [[DataManager defaultInstance] saveContext];
    return datas;
}

#pragma mark - Login

- (NSMutableArray *)parserRepeatRegist:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * mdict = (NSMutableDictionary*)dict;
    NSString* result = [mdict objectForKey:@"result"];
    [array addObject:result];
    return array;
}

- (NSMutableArray *)parserVerificationCode:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * mdict = (NSMutableDictionary*)dict;
    NSString* result = [mdict objectForKey:@"result"];
    [array addObject:result];
    return array;
}

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

#pragma mark - activity

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

#pragma mark - bingRoom

- (NSMutableArray *)parserCheckBingRoom:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dic = (NSMutableDictionary *)dict;
    [array addObject:dic];
    return array;
}
- (NSMutableArray *)parserBindRoom:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dic = (NSDictionary *)dict;
    DBBindCustom *custombing = [[DataManager defaultInstance] getCustomerBingRoom];
    custombing.customerId = dic[@"customerId"];
    custombing.imAccount = dic[@"imAccount"];
    [array addObject:custombing];
    return array;
}
@end
