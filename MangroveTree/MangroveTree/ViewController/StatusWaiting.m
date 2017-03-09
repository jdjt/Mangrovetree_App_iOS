//
//  StatusWaiting.m
//  mgmanager
//
//  Created by Sun Peng on 15/12/12.
//  Copyright © 2015年 Beijing Century Union. All rights reserved.
//

#import "StatusWaiting.h"

@implementation StatusWaiting

- (NSString*)statusName
{
    return @"等待接单中";
}

- (NSString*)cancelButtonText
{
    return @"取消呼叫";
}

- (NSInteger)statusValue
{
    return STATUS_WAITING;
}

@end
