//
//  NetWorkHelp.m
//  mgmanager
//
//  Created by 刘超 on 15/5/15.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "NetWorkHelp.h"

@implementation NetWorkHelp

- (BOOL)ComparingNetworkRequestTime:(NSString *)ident ByUser:(BOOL)byUser
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"NetworkInterface.plist"];
    //判断是否以创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        
    }
    else
    {
        //如果没有plist文件就自动创建
        NSMutableDictionary *dictplist = [[NSMutableDictionary alloc ] init];
        //写入文件
        [dictplist writeToFile:plistPath atomically:YES];
    }
    NSMutableDictionary *applist = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    
    BOOL refresh = YES;
    
    if ([ident isEqualToString:@URI_CALENDAR_ARRAY])//日历数据
    {
       refresh = [self getCalendarList:applist withFilePath:plistPath WithByUser:byUser];
        
    }else if ([ident isEqualToString:@URI_BUILDING_INFO])//酒店building列表
    {
        refresh = [self getBuildingList:applist withFilePath:plistPath WithByUser:byUser];
    }else if ([ident isEqualToString:@URI_FOOD_ARRAY])//所有food列表
    {
        refresh = [self getAllFoodList:applist withFilePath:plistPath WithByUser:byUser];
    }else if ([ident isEqualToString:@REPAST_PARAMS])//点餐列表
    {
        refresh = [self getAllMenuOrderList:applist withFilePath:plistPath WithByUser:byUser];
    }
    
    return refresh;

}


#pragma mark - 餐厅列表

- (BOOL)getTheRestaurantList :(NSMutableDictionary *)applist withFilePath:(NSString *)filePath WithByUser:(BOOL)byUser
{
    NSDate *nowTime = [NSDate date];
    //上次请求时间
    NSDate * lastTime = [applist objectForKey:@"URI_REPAST_LIST"];
    //时间间隔
    NSString *longTime = [self detailDateStrFromDate:lastTime withByUser:byUser];
    
    if ([longTime isEqualToString:@"1"])
    {
        [applist setObject:nowTime forKey:@"URI_REPAST_LIST"];
        //输入写入
        [applist writeToFile:filePath atomically:YES];
        return YES;
    }else
    {
        return NO;
    }

}

#pragma mark - 服务列表

- (BOOL)getTheServicesList :(NSMutableDictionary *)applist withFilePath:(NSString *)filePath WithByUser:(BOOL)byUser
{
    NSDate *nowTime = [NSDate date];
    //上次请求时间
    NSDate * lastTime = [applist objectForKey:@"URI_SERVICES"];
    //时间间隔
    NSString *longTime = [self detailDateStrFromDate:lastTime withByUser:byUser];
    
    if ([longTime isEqualToString:@"1"])
    {
        [applist setObject:nowTime forKey:@"URI_SERVICES"];
        //输入写入
        [applist writeToFile:filePath atomically:YES];
        return YES;
    }else
    {
        return NO;
    }
}

#pragma mark - 商铺列表

- (BOOL)getTheShopList :(NSMutableDictionary *)applist withFilePath:(NSString *)filePath WithByUser:(BOOL)byUser
{
    NSDate *nowTime = [NSDate date];
    //上次请求时间
    NSDate * lastTime = [applist objectForKey:@"URI_SHOPS_ARRY"];
    //时间间隔
    NSString *longTime = [self detailDateStrFromDate:lastTime withByUser:byUser];
    
    if ([longTime isEqualToString:@"1"])
    {
        [applist setObject:nowTime forKey:@"URI_SHOPS_ARRY"];
        //输入写入
        [applist writeToFile:filePath atomically:YES];
        return YES;
    }else
    {
        return NO;
    }

}

#pragma mark - 日历数据

- (BOOL)getCalendarList :(NSMutableDictionary *)applist withFilePath:(NSString *)filePath WithByUser:(BOOL)byUser
{
    NSDate *nowTime = [NSDate date];
    //上次请求时间
    NSDate * lastTime = [applist objectForKey:@"URI_CALENDAR_ARRAY"];
    //时间间隔
    NSString *longTime = [self detailDateStrFromDate:lastTime withByUser:byUser];
    
    if ([longTime isEqualToString:@"1"])
    {
        [applist setObject:nowTime forKey:@"URI_CALENDAR_ARRAY"];
        //输入写入
        [applist writeToFile:filePath atomically:YES];
        return YES;
    }else
    {
        return NO;
    }

}

#pragma mark - 酒店列表

- (BOOL)getBuildingList :(NSMutableDictionary *)applist withFilePath:(NSString *)filePath WithByUser:(BOOL)byUser
{
    NSDate *nowTime = [NSDate date];
    //上次请求时间
    NSDate * lastTime = [applist objectForKey:@"URI_BUILDING_INFO"];
    //时间间隔
    NSString *longTime = [self detailDateStrFromDate:lastTime withByUser:byUser];
    
    if ([longTime isEqualToString:@"1"])
    {
        [applist setObject:nowTime forKey:@"URI_BUILDING_INFO"];
        //输入写入
        [applist writeToFile:filePath atomically:YES];
        return YES;
    }else
    {
        return NO;
    }

}

#pragma mark - 所有food列表

- (BOOL)getAllFoodList :(NSMutableDictionary *)applist withFilePath:(NSString *)filePath WithByUser:(BOOL)byUser
{
    NSDate *nowTime = [NSDate date];
    //上次请求时间
    NSDate * lastTime = [applist objectForKey:@"URI_FOOD_ARRAY"];
    //时间间隔
    NSString *longTime = [self detailDateStrFromDate:lastTime withByUser:byUser];
    
    if ([longTime isEqualToString:@"1"])
    {
        [applist setObject:nowTime forKey:@"URI_FOOD_ARRAY"];
        //输入写入
        [applist writeToFile:filePath atomically:YES];
        return YES;
    }else
    {
        return NO;
    }
}

#pragma mark - 点餐列表

- (BOOL)getAllMenuOrderList :(NSMutableDictionary *)applist withFilePath:(NSString *)filePath WithByUser:(BOOL)byUser
{
    NSDate *nowTime = [NSDate date];
    //上次请求时间
    NSDate * lastTime = [applist objectForKey:@"REPAST_PARAMS"];
    //时间间隔
    NSString *longTime = [self detailDateStrFromDate:lastTime withByUser:byUser];
    
    if ([longTime isEqualToString:@"1"])
    {
        [applist setObject:nowTime forKey:@"REPAST_PARAMS"];
        //输入写入
        [applist writeToFile:filePath atomically:YES];
        return YES;
    }else
    {
        return NO;
    }
}

//获取时间差
/**
 *  1 超过一天活着主动刷新，2 超过十分钟小于一个小时，3 其他
 */
- (NSString *) detailDateStrFromDate:(NSDate *) date withByUser:(BOOL)byUser
{
    //现在时间
    NSDate *currentDate = [NSDate date];
    
    double seconds = [currentDate timeIntervalSinceDate:date];
    double minutes = seconds/60;
    double hours = minutes/60;
    double days = hours/24;
    
    if (byUser == NO)
    {
        if (date == nil || days >= 1 )
        {
            return @"1";
        }
    }
    
    if (byUser == YES)
    {
        return @"1";
    }

    if (minutes < 10)
    {
        return @"3";
    }
    if (minutes >= 10 && hours < 1)
    {
        return @"2";
    }
    if (days >= 1)
    {
        return @"1";
    }
    
    return @"3";
    
}

@end
