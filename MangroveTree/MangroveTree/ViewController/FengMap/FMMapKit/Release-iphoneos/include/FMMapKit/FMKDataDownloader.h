//
//  FMRequestManager.h
//  FMMapKit
//
//  Created by FengMap on 15/4/30.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  蜂鸟下载类的封装
 *  用于下载蜂鸟服务器提供的数据
 *  数据现有：地图数据，主题数据，图片数据
 */

@class FMKHttpRequest;

/**
 *  提供蜂鸟地图和主题数据的下载
 */
@interface FMKDataDownloader : NSObject
/**
 *  同步请求地图文件，地图文件会保存在sdk地图目录下
 *
 *  @param mapID   地图ID
 *  @param failure 请求成功
 *
 *  @return 同步请求返回的数据
 */
+ (NSData *)syncRequestMapWithID:(NSString *)mapID
						 failure:(void(^)(NSError* error))failure;

/**
 *  异步请求地图文件,地图文件会保存在sdk地图目录下
 *
 *  @param mapID   地图ID
 *  @param finish  请求成功
 *  @param failure 请求失败
 */
+ (void)asynRequestMapWithID:(NSString *)mapID
					  finish:(void (^)(FMKHttpRequest* request,NSData* responseData))finish
					 failure:(void (^)(NSError* error))failure;

/**
 * 该请求为异步请求
 * @brief 下载当前地图主题文件，下载后的数据可通过FMKThemeDataManager解压
 * 注：下载文件为压缩文件，解压后的文件需要放在同一目录下，否则可能会导致错误
 * @param themeID 主题id
 */
+ (void)downloadThemeWithID:(NSString *)themeID
					 finish:(void (^)(FMKHttpRequest* request,NSData* responseData))finish
					failure:(void (^)(NSError* error))failure;



@end

