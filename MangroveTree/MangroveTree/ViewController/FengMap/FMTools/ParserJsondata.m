//
//  ParserJsondata.m
//  StaticModelDemo
//
//  Created by fengmap on 16/6/7.
//  Copyright © 2016年 FengMap. All rights reserved.
//

#import "ParserJsondata.h"
#import "FMActivity.h"
#import "FMZone.h"
#import "FMRoute.h"
#import "IndoorMapInfo.h"

@implementation ParserJsondata

+ (FMZone *)parserFacility
{
	NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"facility.json" ofType:nil];
	NSDictionary * dic = [ParserJsondata parserByJsonPath:jsonPath];
	
	FMZone * zoneActivity = [[FMZone alloc] init];
	[zoneActivity setValuesForKeysWithDictionary:dic];
	return zoneActivity;
}

+ (FMZone *)parserFood
{
	NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"food.json" ofType:nil];
	NSDictionary * dic = [ParserJsondata parserByJsonPath:jsonPath];
	FMZone * zoneActivity = [[FMZone alloc] init];
	[zoneActivity setValuesForKeysWithDictionary:dic];
	return zoneActivity;
}

+ (FMZone *)parserShop
{
	NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"shop.json" ofType:nil];
	NSDictionary * dic = [ParserJsondata parserByJsonPath:jsonPath];
	FMZone * zoneActivity = [[FMZone alloc] init];
	[zoneActivity setValuesForKeysWithDictionary:dic];
	return zoneActivity;
}

+ (FMRoute *)parserRouteFood1
{
	NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"route_food_1.json" ofType:nil];
	NSDictionary * dic = [ParserJsondata parserByJsonPath:jsonPath];
	FMRoute * routeActivity = [[FMRoute alloc] init];
	[routeActivity setValuesForKeysWithDictionary:dic];
	return routeActivity;
}

+ (FMRoute *)parserRouteRelax1
{
	NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"route_relax_1.json" ofType:nil];
	NSDictionary * dic = [ParserJsondata parserByJsonPath:jsonPath];
	FMRoute * routeActivity = [[FMRoute alloc] init];
	[routeActivity setValuesForKeysWithDictionary:dic];
	return routeActivity;
}
+ (FMRoute *)parserRouteShop1
{
	NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"shop1.json" ofType:nil];
	NSDictionary * dic = [ParserJsondata parserByJsonPath:jsonPath];
	FMRoute * routeActivity = [[FMRoute alloc] init];
	[routeActivity setValuesForKeysWithDictionary:dic];
	return routeActivity;
}

+ (NSArray <FMActivity *>*)parserActivities
{
	NSMutableArray * activitys = [NSMutableArray array];
	NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"acts.json" ofType:nil];
	NSDictionary * dic = [ParserJsondata parserByJsonPath:jsonPath];
	NSArray * arr = dic[@"activity_list"];
	for ( NSDictionary * ac in arr) {
		FMActivity * activity = [[FMActivity alloc] init];
		[activity setValuesForKeysWithDictionary:ac];
		[activitys addObject:activity];
	}
	return activitys;
}

+ (NSDictionary *)parserLJJson
{
	NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"FMHSLlujing.json" ofType:nil];
	return [ParserJsondata parserByJsonPath:jsonPath];
}

+ (NSArray *)parserIndoorMap
{
	NSMutableArray * mapInfos = [NSMutableArray array];
	NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"indoorMapInfo.json" ofType:nil];
	NSDictionary * dic = [ParserJsondata parserByJsonPath:jsonPath];
	NSArray * arr = dic[@"indoormaps"];
	for (NSDictionary * info in arr) {
		IndoorMapInfo * mapInfo = [[IndoorMapInfo alloc] init];
		[mapInfo setValuesForKeysWithDictionary:info];
		[mapInfos addObject:mapInfo];
	}
	return mapInfos;
}

+ (NSDictionary *)parserByJsonPath:(NSString *)jsonPath
{
	NSData * data = [[NSData alloc] initWithContentsOfFile:jsonPath];
	if(!data) return nil;
	NSError * error = nil;
	NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//	if (nil == error) {
//		return dic;
//	}
	return dic;
}

@end
