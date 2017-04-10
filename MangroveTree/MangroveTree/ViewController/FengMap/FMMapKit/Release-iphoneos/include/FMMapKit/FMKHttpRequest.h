//
//  FMKHttpRequest.h
//  FMMapKit
//
//  Created by FengMap on 15/4/30.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 自定义请求类
 */
typedef unsigned long long FMUnLongLong;

@protocol FMKHttpRequestDelegate;

@interface FMKHttpRequest : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic,weak)  id<FMKHttpRequestDelegate> delegate;

///数据下载地址
@property (nonatomic,readonly) NSString* httpURL;

/// @brief 请求数据总大小
@property (nonatomic,readonly) FMUnLongLong totalSize;
/**
 *  当前请求数据的大小
 */
@property (nonatomic,readonly) FMUnLongLong currentSize;

/** @brief 从指定网站请求数据
 *  @param path 本地缓存位置
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)asynRequestFromURL:(NSURL *)url
                   success:(void (^)(FMKHttpRequest* request,NSData* responseData))success
                   failure:(void (^)(NSError* error))failure;
///停止请求
- (void)stopRequest;

@end

@protocol FMKHttpRequestDelegate <NSObject>

- (void)request:(FMKHttpRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(FMKHttpRequest *)request didReceiveData:(NSData *)data;
- (void)requestDidFinishLoading:(FMKHttpRequest *)request;

@end









