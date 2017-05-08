//
//  FMMapSDK.h
//  FMMapKit
//
//  Created by FengMap on 15/4/29.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	获取当前地图SDK的版本号
 *	return  返回当前SDK的版本号
 */

FOUNDATION_STATIC_INLINE NSString * FMKGetMapSDKVersion()
{
	return @"1.6.3";
}

@interface FMKMapSDK : NSObject

//启用SDK,配置本地文件
+ (instancetype)shareSDK;

/**
 *  使用SDK需要先验证apiKey
 *
 *  @param apiKey 需要从蜂鸟SDK网站获取
 *  @param target 若需关注网络及授权验证事件，请设定
 *
 *  @return 返回验证结果，若成功则可顺利使用SDK进行开发
 */
- (BOOL)start:(NSString *)apiKey generalDelegate:(id)target;

- (NSString *)getVersion;

@end
