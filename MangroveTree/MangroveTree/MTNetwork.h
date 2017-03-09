//
//  MTNetwork.h
//  mgmanager
//
//  Created by 罗禹 on 16/7/5.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef  void (^YiWuResponseSuccess)(id responseObject,NSURLSessionTask * task);  //请求成功block
typedef  void (^YiWuResponseFailure)(NSError * error,NSURLSessionTask * task);    //请求失败block

@interface MTNetwork : NSObject

@property (nonatomic,strong) AFHTTPSessionManager * manager;

@property (nonatomic,copy) NSString * requestURL; //url

@property (nonatomic,copy) NSString * topHead; //http:和https:

@property (nonatomic,copy) NSString * serverAddress; //服务器地址

@property (nonatomic,strong) NSDictionary * params; //参数

@property (nonatomic,strong) NSURLSessionTask * task; //控制请求

@property (nonatomic,copy) NSString * url; //整体的

/**
 *  @abstract  初始化
 *  @params  tophead        http: or https:
 *  @params  serverAddress  服务器地址
 *  @params  url            地址
 *  @params  params         参数
 *
 */
- (instancetype)initWithTopHead:(NSString *)tophead serverAddress:(NSString *)serverAddress requestURL:(NSString *)url params:(NSDictionary *)params;

/**
 *  @abstract  设置请求头
 *      headers
 */
+ (void)setHeaders:(NSDictionary *)headers;

/**
 *  @abstract  取消请求
 */
- (void)cancleRequest;

/**
 *  @abstract  取消所有请求
 */
- (void)cancleAllRequest;

/**
 *  @abstract  POST开始请求
 *  @param  success  请求成功返回的block块
 *  @param  failure  请求失败返回的block块
 *  @return  返回对象可控制该请求(不管就好)
 */
- (NSURLSessionTask *)POSTWithSuccess:(YiWuResponseSuccess)success
                              failure:(YiWuResponseFailure)failure;

@end
