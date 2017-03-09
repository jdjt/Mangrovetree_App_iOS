//
//  StatusAcceptExpired.m
//  mgmanager
//
//  Created by Sun Peng on 15/12/12.
//  Copyright © 2015年 Beijing Century Union. All rights reserved.
//

#import "StatusAcceptExpired.h"

@implementation StatusAcceptExpired

- (NSString*)statusName
{
    return @"已取消（超时）";
}

- (NSString*)cancelButtonText
{
    return @"取消呼叫";
}

- (NSInteger)statusValue
{
    return STATUS_ACCEPT_EXPIRED;
}

@end
