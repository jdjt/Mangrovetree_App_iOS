//
//  ParserJsondata.h
//  StaticModelDemo
//
//  Created by fengmap on 16/6/7.
//  Copyright © 2016年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMActivity,FMRoute,FMZone;


@interface ParserJsondata : NSObject

//获取所有的activity数据
//+ (NSArray <FMActivity *>*)parserActivities;

//获取设施数据
+ (FMZone *)parserFacility;
//获取美食数据
+ (FMZone *)parserFood;
//获取购物数据
+ (FMZone *)parserShop;
//获取美食路线1数据
+ (FMRoute *)parserRouteFood1;
//获取休闲路线1数据
+ (FMRoute *)parserRouteRelax1;
+ (FMRoute *)parserRouteShop1;
+ (NSDictionary *)parserLJJson;

+ (NSArray *)parserIndoorMap;


@end
