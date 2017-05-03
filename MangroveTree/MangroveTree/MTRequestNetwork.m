//
//  MTRequestNetwork.m
//  mgmanager
//
//  Created by 罗禹 on 16/7/5.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "MTRequestNetwork.h"
#import "MySingleton.h"
#import "PDKeyChain.h"

@interface MTRequestNetwork ()

@property (nonatomic,strong) NSMutableArray * delegateArray;
@property (nonatomic, assign) NSInteger loginCount;
@property (nonatomic, strong) MBProgressHUD * hud;

@end

@implementation MTRequestNetwork

// 单例
+ (instancetype)defaultManager
{
    static MTRequestNetwork * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
        manager.delegateArray = [[NSMutableArray alloc]init];
        manager.loginCount = 0;
    });
    
    return manager;
}

#pragma mark - 设置代理
// 注册代理
- (void)registerDelegate:(id<MTRequestNetWorkDelegate>)delegate
{
    if (delegate)
    {
        for (id<MTRequestNetWorkDelegate> delegatenet in self.delegateArray)
        {
            if (delegatenet == delegate)
                return;
        }
        [self.delegateArray addObject:delegate];
    }
}

// 注销代理
- (void)removeDelegate:(id<MTRequestNetWorkDelegate>)delegate
{
    if (delegate)
    {
        [self.delegateArray removeObject:delegate];
    }
}

#pragma mark - 网络请求方法

// 开始请求
- (NSURLSessionTask *)POSTWithTopHead:(NSString *)tophead webURL:(NSString *)url params:(NSDictionary *)params withByUser:(BOOL)byUser andOldInterfaces:(BOOL)old
{
    self.topHead = tophead;
    self.requestURL = url;
    self.params = params;
    
    // 判断服务器地址
    NSInteger severIndex = [Util SelectTheServerUrl];
    self.serverAddress = [[MySingleton sharedSingleton] currentServiceAddress:severIndex byInterFaceType:old];
    NetWorkHelp *netWorkHelp = [[NetWorkHelp alloc] init];
    
    // 判断查询间隔是否满足足够长的状态（当byUser为NO时，间隔不够时将不发送实际请求）
    BOOL sendNetWork = [netWorkHelp ComparingNetworkRequestTime:url ByUser:byUser];
    if (sendNetWork == NO) {
        return nil;
    }else {
        NSTimeInterval timestamp = [Util timestamp];
        // 设置请求头
        NSString* tokenid = @"";
        BOOL isLogIn = [[DataManager defaultInstance] findUserLogIn];
        if (isLogIn == YES )
        {
            DBUserLogin *userLogin = [[DataManager defaultInstance] findUserLogInByCode:@"1"];
            tokenid = userLogin.ticker;
        }
        NSMutableDictionary* header = [[NSMutableDictionary alloc]init];
        [header setObject:@"application/json; charset=utf-8" forKey:@"Content-Type"];
        [header setObject:tokenid forKey:@"mymhotel-ticket"];
        [header setObject:@"1006" forKey:@"mymhotel-type"];
        [header setObject:@"4.0" forKey:@"mymhotel-version"];
        [header setObject:@"JSON" forKey:@"mymhotel-dataType"];
        [header setObject:@"JSON" forKey:@"mymhotel-ackDataType"];
        [header setObject:[self getsourceCode] forKey:@"mymhotel-sourceCode"];
        [header setObject:[NSString stringWithFormat:@"%f",timestamp] forKey:@"mymhotel-dateTime"];
        [header setObject:@"no-cache" forKey:@"Pragma"];
        [header setObject:@"no-cache" forKey:@"Cache-Control"];
        [MTNetwork setHeaders:header];
        // 代理方法请求开始
        for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray)
        {
            if (delegate && [delegate respondsToSelector:@selector(startRequest:)])
            {
                [delegate startRequest:nil];
                [self startHUD];
            }
        }
        NSURLSessionTask * urltask =  [self POSTWithSuccess:^(id responseObject,NSURLSessionTask * task) {
            [self parseResult:responseObject urltask:task url:url params:(NSDictionary *)params succeed:YES andOldInterfaces:old];
        } failure:^(NSError *error,NSURLSessionTask * task) {
            [self parseResult:error urltask:task url:url params:(NSDictionary *)params succeed:NO andOldInterfaces:old];
        }];
        return urltask;
    }

}
#pragma mark - 请求结果

// 返回结果
- (void)parseResult:(id)responseObj urltask:(NSURLSessionTask *)task url:(NSString *)viewURL params:(NSDictionary *)params succeed:(BOOL)succeed andOldInterfaces:(BOOL)old
{
    NSLog(@"返回数据::::::::::::::::%@",responseObj);
    [self removeHUD];
    // 请求成功
    if (succeed)
    {
        // 旧接口处理返回数据
        if (old == YES)
        {
            NSLog(@"旧接口");
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSDictionary *allHeaders = response.allHeaderFields;
            NSString *responseCode = [allHeaders objectForKey:@"mymhotel-status"];
            NSString *responseMsg = [allHeaders objectForKey:@"mymhotel-message"];
            NSLog(@"旧接口错误信息:mymhotel-status == %@  mymhotel-message == %@",responseCode,responseMsg);
            // 无响应：网络连接失败
            if (responseCode == NULL)
            {
                for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
                    if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailing:responseCode:withMessage:)]) {
                        [delegate pushResponseResultsFailing:task responseCode:responseCode withMessage:@"联网失败,请重新尝试联网"];
                    }
                }
                return;
            }
            
            // 有网络连接
            NSString *unicodeStr = [NSString stringWithCString:[responseMsg cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
            NSLog(@"返回的 错误信息:%@", unicodeStr);
            
//            // 解析状态数据
            NSArray* msgs = [unicodeStr componentsSeparatedByString:@"|"];
            // 登录失败或者超时的情况，自动登录一次（之前的操作未完成，需要用户重新点击发起操作）
            // if (![msgs[0] isEqualToString:@"OK"])
            if ([msgs[0] isEqualToString:@"EBA013"]
                ||[msgs[0] isEqualToString:@"TICKET_ISNULL"]
                ||[msgs[0] isEqualToString:@"TOKEN_INVALID"]
                ||[msgs[0] isEqualToString:@"UNLOGIN"]
                ||[msgs[0] isEqualToString:@"EBF001"]
                ||[msgs[0] isEqualToString:@"EBF003"]
                ||[msgs[0] isEqualToString:@"ES0003"]
                ||[msgs[0] isEqualToString:@"EBCALL001"])
            {
                [self logIn];
                return;
            }
            // 返回无数据的状态
            if (msgs != nil && msgs.count > 1)
            {
                NSRange range = [msgs[1] rangeOfString:@"不存在"];
                if ([responseCode isEqualToString:@"ERR"]
                    || [msgs[1]isEqualToString:@"无数据"]
                    || [msgs[1]isEqualToString:@"数据空"]
                    || range.length > 0)
                {
                    NSLog(@"111111111111111111111");
                    for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
                        if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailing:responseCode:withMessage:)]) {
                            [delegate pushResponseResultsFailing:task responseCode:responseCode withMessage:msgs[1]];
                        }
                    }
                    return;
                }
            }
            // msg如果不是两段数据也提示返回错误？
            else
            {
                NSLog(@"2222222222222");
                for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray)
                {
                    if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailing:responseCode:withMessage:)])
                    {
                        [delegate pushResponseResultsFailing:task responseCode:responseCode withMessage:unicodeStr];
                    }
                }
                return;
            }
            
            // 解析返回的数据
//            NSString *jsonStr = [[NSString alloc] initWithString:[responseObj responseStringFormatUTF8]];//Data:
//            NSLog(@"jsonStr:%@", jsonStr);
            // 有返回数据的请求
            Parser *parser = [[Parser alloc]init];
            if (params != nil)
                parser.params = [NSMutableDictionary dictionaryWithObject:params forKey:viewURL];
            NSMutableArray* array = [parser parser:viewURL fromData:responseObj];

            if (responseObj != nil && [msgs[0] isEqualToString:@"00"])
            {
                @try
                {
                    // 不需要返回数据的请求
                    if (array.count < 1)
                    {
                        for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray)
                        {
                            if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsSucceed:responseCode:withMessage:andData:)])
                            {
                                [delegate pushResponseResultsSucceed:task responseCode:responseCode withMessage:@"请求成功" andData:nil];
                            }
                            return;
                        }
                    }
                    
                    // 有返回数据的请求
                    for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
                        if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsSucceed:responseCode:withMessage:andData:)]) {
                            [delegate pushResponseResultsSucceed:task responseCode:responseCode withMessage:@"" andData:array];
                        }
                    }
                    return;
                }
                @catch (NSException *exception)
                {
                }
            }
            else if (responseObj == nil && [msgs[0] isEqualToString:@"00"])
            {
                // 有返回数据的请求
                for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
                    if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsSucceed:responseCode:withMessage:andData:)]) {
                        [delegate pushResponseResultsSucceed:task responseCode:responseCode withMessage:@"请求成功" andData:nil];
                    }
                }
            }
        }
        // 新接口处理返回数据
        else
        {
            NSLog(@"新接口处理返回数据");
            NSString * errorCode =  [NSString stringWithFormat:@"%@",responseObj[@"error"][@"code"]];
            NSString * errorInfo =  [NSString stringWithFormat:@"%@",responseObj[@"error"][@"info"]];
            if (![errorCode isEqualToString:@"0"])
            {
                for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
                    if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailing:responseCode:withMessage:)]) {
                        [delegate pushResponseResultsFailing:task responseCode:errorCode withMessage:errorInfo];
                    }
                }
                return;
            }
            if (responseObj != nil) {
                @try
                {
                    Parser *parser = [[Parser alloc]init];
                    parser.params = [NSMutableDictionary dictionaryWithObject:params forKey:viewURL];
                    NSMutableArray* array = [parser parser:viewURL fromData:responseObj];
                    
                    // 不需要返回数据的请求
                    if (array.count < 1){
                        for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
                            if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsSucceed:responseCode:withMessage:andData:)]) {
                                [delegate pushResponseResultsSucceed:task responseCode:errorCode withMessage:errorInfo andData:nil];
                            }
                        }
                        return;
                    }
                    // 有返回数据的请求
                    for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray) {
                        if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsSucceed:responseCode:withMessage:andData:)]) {
                            [delegate pushResponseResultsSucceed:task responseCode:errorCode withMessage:errorInfo andData:array];
                        }
                    }
                    return;
                }
                @catch (NSException *exception){
                }
            }
        }
    }
    // 请求失败
    else
    {
        NSError * error = responseObj;
        for (id<MTRequestNetWorkDelegate> delegate in self.delegateArray)
        {
            if (delegate && [delegate respondsToSelector:@selector(pushResponseResultsFailing:responseCode:withMessage:)]) {
                [delegate pushResponseResultsFailing:task responseCode:[NSString stringWithFormat:@"%ld",error.code] withMessage:error.description];
            }
        }
    }
}

- (void)startHUD
{
    if (!self.hud)
    {
        self.hud = [[MBProgressHUD alloc] initWithWindow:[AppDelegate sharedDelegate].window];
        [[AppDelegate sharedDelegate].window addSubview:self.hud];
        self.hud.labelText = @"正在加载";
        [self.hud hide:NO];
        [self.hud show:YES];
    }
}
- (void)removeHUD
{
    
    if (self.hud)
    {
        [self.hud hide:YES];
        [self.hud removeFromSuperview];
        self.hud = nil;
    }
}

- (NSString *)getsourceCode
{
    NSString *sourceCode = [Util macaddress];
    
    NSString *deviceToken = [[DataManager defaultInstance] getParameter].deviceToken;
    NSString *token = @"1";
    if (deviceToken)
        sourceCode = [NSString stringWithFormat:@"%@|%@",sourceCode,deviceToken];
    else
        sourceCode = [NSString stringWithFormat:@"%@|%@",sourceCode,token];
    return sourceCode;
}

#pragma mark - 自动登录

- (void)logIn
{
    self.loginCount++;
    if (self.loginCount > 2)
    {
        self.loginCount = 0;
        return;
    }
    
    DBUserLogin *user =  [[DataManager defaultInstance] findUserLogInByCode:@"1"];
    
    if (user == nil //没有用户，返回
        || ([Util isEmptyOrNull:user.account]&&[Util isEmptyOrNull:user.email]) // 用户账号（手机号）和邮箱同时为空
        || [Util isEmptyOrNull:user.password]) // 没有用户密码
        return;
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    [params setObject:(user.account == nil || [user.account isEqualToString:@""]) ? user.email : user.account forKey:@"account"];
    [params setObject:user.password forKey:@"password"];
    [self POSTWithTopHead:@REQUEST_HEAD_NORMAL
                   webURL:@URI_LOGIN
                   params:params
               withByUser:YES
         andOldInterfaces:YES];
}

@end
