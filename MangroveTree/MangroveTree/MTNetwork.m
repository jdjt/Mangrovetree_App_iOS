//
//  MTNetwork.m
//  mgmanager
//
//  Created by 罗禹 on 16/7/5.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "MTNetwork.h"

static NSDictionary * _headers;

@implementation MTNetwork

// 初始化请求 设置参数
- (instancetype)initWithTopHead:(NSString *)tophead serverAddress:(NSString *)serverAddress requestURL:(NSString *)url params:(NSDictionary *)params
{
    if (self = [super init])
    {
        self.topHead = tophead;
        self.serverAddress = serverAddress;
        self.requestURL = url;
        self.url = [NSString stringWithFormat:@"%@%@%@",_topHead,_serverAddress,_requestURL];
        self.params = params;
    }
    return self;
}

// 设置请求头
+ (void)setHeaders:(NSDictionary *)headers {
    _headers = headers;
}

// 取消单个请求
- (void)cancleRequest
{
    [self.task cancel];
}

// 取消所有请求
- (void)cancleAllRequest
{
    [_manager.operationQueue cancelAllOperations];
}

// post请求 返回NSURLSessionTask实例 用于区别请求 和控制请求
- (NSURLSessionTask *)POSTWithSuccess:(YiWuResponseSuccess)success failure:(YiWuResponseFailure)failure
{
    
    AFHTTPSessionManager * manager = [self manager];
    __weak __typeof(self) weakSelf = self;     
    weakSelf.url = [NSString stringWithFormat:@"%@%@%@",_topHead,_serverAddress,_requestURL];
    NSURLSessionTask * urltask = [manager POST:weakSelf.url
                                    parameters:weakSelf.params
                                      progress:nil
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           if (success)
                                           {
                                               success(responseObject,task);
                                               NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                                               NSDictionary *allHeaders = response.allHeaderFields;
                                               NSLog(@"______________%@",allHeaders);
                                           }
                                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           if (failure)
                                           {
                                               failure(error,task);
                                           }
                                       }];
    NSLog(@"url = %@",self.url);
    NSLog(@"params = %@",self.params);
    return urltask;
}

// 设置请求对象参数
- (AFHTTPSessionManager *)manager
{
    self.manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer.timeoutInterval = 15;
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    for (NSString *key in _headers)
    {
         [_manager.requestSerializer setValue:_headers[key] forHTTPHeaderField:key];
    }
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                               @"text/html",
                                                                               @"text/json",
                                                                               @"text/plain",
                                                                               @"text/javascript",
                                                                               @"text/xml",
                                                                               @"image/*"]];
    return _manager;
}

@end
