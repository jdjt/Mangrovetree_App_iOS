//
//  MySingleton.m
//  BeautyDiary
//
//  Created by 王 玲玲 on 13-8-5.
//  Copyright (c) 2013年 王 玲玲. All rights reserved.
//

#import "MySingleton.h"

@implementation MySingleton

@synthesize sessionId;
@synthesize baseInterfaceUrl = _baseInterfaceUrl;
@synthesize weixinInterfaceUrl=_weixinInterfaceUrl;

+ (MySingleton *)sharedSingleton
{
    static MySingleton *sharedSingleton=nil;
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[MySingleton alloc] init];
        
        return sharedSingleton;
    }
}

//基础地址要改为
-(id)init
{
    self = [super init];
    if (self)
    {
        _baseInterfaceUrl = @"mws.mymhotel.com";    // 正式服务器
        _testUrl = @"rc-ws.mymhotel.com";
//        _testUrl = @"103.4.58.124:8181";            // 测试服务器
        _interTestUrl = @"192.168.1.45:8181";       // 测试服务器（专线）
    }
    
    return self;
}

- (NSString *)currentServiceAddress:(NSInteger)severIndex byInterFaceType:(BOOL)type
{
    NSString *serviceAddress = nil;
    switch (severIndex)
    {
        case 1:
            serviceAddress = type == YES ? @"rc-ws.mymhotel.com" : @"103.4.58.124:8080";//@"192.168.10.163:8080";//
            break;
        case 2:
            serviceAddress = [MySingleton sharedSingleton].interTestUrl;
            break;
        case 0:
        default:
            serviceAddress = type == YES ?@"mws.mymhotel.com" : @"syw.mymhotel.com";
            break;
    }
    
    return serviceAddress;
}
@end
