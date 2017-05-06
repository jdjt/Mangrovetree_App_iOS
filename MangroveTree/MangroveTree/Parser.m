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
    }else if ([ident isEqualToString:URL_CANCEL_LIST])// 取消原因列表
    {
        datas = [self parserCancelReasonList:dict];
    }else if ([ident isEqualToString:URL_GETTASK_TASKCODE])// 获取任务详情 根据taskCode
    {
        datas = [self parserGetTaskDetail:dict];
    }
    else if ([ident isEqualToString:URL_GETTASK_TASKSTATUS])// 获取任务详情 根据taskStatus
    {
        datas = [self parserGetTaskDetailList:dict];
    }
    else if ([ident isEqualToString:URL_SCORETASK])// 任务评分
    {
        datas = [self parserScoreTask:dict];
    }
    else if ([ident isEqualToString:URL_COMFIRMTASK])// 确认任务完成／未完成
    {
        datas = [self parserComfirmTask:dict];
    }
    else if ([ident isEqualToString:URL_CANCEL_TASK])// 取消任务
    {
        datas = [self parserCancelTask:dict];
    }
    else if ([ident isEqualToString:URL_SENG_TASK])// 发送任务
    {
        datas = [self parserSendTask:dict];
    }
    else if ([ident isEqualToString:URL_GETCUSTOMINFO])// 获取住客信息
    {
        datas = [self parserGetCustomInfo:dict];
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
    if (dic[@"customerId"] != nil && ![dic[@"customerId"] isEqualToString:@""])
    {
        DBUserLogin * userLogin = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
        DBBindCustom * bind = [[DataManager defaultInstance] getCustomerBingRoom];
        bind.customerId = dic[@"customerId"];
        userLogin.hasCustomBind = bind;
    }
    [array addObject:dic];
    return array;
}
- (NSMutableArray *)parserBindRoom:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dic = (NSDictionary *)dict;
    DBUserLogin * userLogin = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
    DBBindCustom *custombing = [[DataManager defaultInstance] getCustomerBingRoom];
    custombing.customerId = dic[@"customerId"];
    custombing.imAccount = dic[@"imAccount"];
    userLogin.hasCustomBind = custombing;
    [array addObject:custombing];
    return array;
}

#pragma mark - cancelReasonList

- (NSMutableArray *)parserCancelReasonList:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dic = (NSDictionary *)dict;
    
    for (NSDictionary * listDic in dic[@"cancelCauseList"])
    {
        CancelReasonModel * model = [[CancelReasonModel alloc]init];
        model.causeCode = listDic[@"causeCode"];
        model.causeDesc = listDic[@"causeDesc"];
        [array addObject:model];
    }
    
    return array;
}

#pragma mark - GetTaskDetail

- (NSMutableArray *)parserGetTaskDetail:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dic = (NSDictionary *)dict;
    
    DBCallTask * task = [[DataManager defaultInstance] getCallTaskByTaskCode:dic[@"taskCode"]];
    task.taskContent = dic[@"taskContent"];
    task.taskStatus = dic[@"taskStatus"];
    task.taskStatus = dic[@"taskStatus"];
    task.areaCode = dic[@"areaCode"];
    task.areaName = dic[@"areaName"];
    task.cancelTime = dic[@"cancelTime"];
    task.cancelPoint = dic[@"cancelPoint"];
    task.cancelCode = dic[@"cancelCode"];
    task.cancelDesc = dic[@"cancelDesc"];
    task.scoreTime = dic[@"scoreTime"];
    task.scoreMod = dic[@"scoreMod"];
    task.scoreVal = dic[@"scoreVal"];
    task.customerId = dic[@"customerId"];
    task.cImAccount = dic[@"cImAccount"];
    task.waiterId = dic[@"waiterId"];
    task.wImAccount = dic[@"wImAccount"];
    task.nowDate = dic[@"nowDate"];
    task.acceptTime = dic[@"acceptTime"];
    task.finishTime = dic[@"finishTime"];
    task.finishEndTime = dic[@"finishEndTime"];
    task.produceTime = dic[@"produceTime"];
    task.waiterName = dic[@"waiterName"];
    [array addObject:task];
    
    return array;
}

#pragma mark - GetTaskDetailList

- (NSMutableArray *)parserGetTaskDetailList:(NSData *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary * dic1 = (NSDictionary *)dict;
    
    for (NSDictionary * dic in dic1)
    {
        DBCallTask * task = [[DataManager defaultInstance] getCallTaskByTaskCode:dic[@"taskCode"]];
        task.taskContent = dic[@"taskContent"];
        task.taskStatus = dic[@"taskStatus"];
        task.taskStatus = dic[@"taskStatus"];
        task.areaCode = dic[@"areaCode"];
        task.areaName = dic[@"areaName"];
        task.cancelTime = dic[@"cancelTime"];
        task.cancelPoint = dic[@"cancelPoint"];
        task.cancelCode = dic[@"cancelCode"];
        task.cancelDesc = dic[@"cancelDesc"];
        task.scoreTime = dic[@"scoreTime"];
        task.scoreMod = dic[@"scoreMod"];
        task.scoreVal = dic[@"scoreVal"];
        task.customerId = dic[@"customerId"];
        task.cImAccount = dic[@"cImAccount"];
        task.waiterId = dic[@"waiterId"];
        task.wImAccount = dic[@"wImAccount"];
        task.nowDate = dic[@"nowDate"];
        task.acceptTime = dic[@"acceptTime"];
        task.finishTime = dic[@"finishTime"];
        task.finishEndTime = dic[@"finishEndTime"];
        task.produceTime = dic[@"produceTime"];
        task.waiterName = dic[@"waiterName"];
        [array addObject:task];
    }
    
    return array;
}

#pragma mark - ScoreTask

- (NSMutableArray *)parserScoreTask:(NSData *)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    
    [array addObject:dic];
    
    return array;
}

#pragma mark - ComfirmTask

- (NSMutableArray *)parserComfirmTask:(NSData *)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    
    [array addObject:dic];
    
    return array;
}

#pragma mark - CancelTask

- (NSMutableArray *)parserCancelTask:(NSData *)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    
    [array addObject:dic];
    
    return array;
}

#pragma mark - SendTask

- (NSMutableArray *)parserSendTask:(NSData *)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    
    [[DataManager defaultInstance] getCallTaskByTaskCode:dic[@"taskCode"]];
    [array addObject:dic];
    
    return array;
}

#pragma mark - GetCustomInfo

- (NSMutableArray *)parserGetCustomInfo:(NSData *)dict
{
    NSMutableArray * array = [NSMutableArray array];
    NSDictionary * dic = (NSDictionary *)dict;
    
    DBUserLogin * user = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
    DBBindCustom * bind = [[DataManager defaultInstance] getCustomerBingRoom];
    bind.customerId = dic[@"customerId"];
    bind.imAccount = dic[@"imAccount"];
    user.hasCustomBind = bind;
    
    [array addObject:bind];
    
    return array;
}

@end
