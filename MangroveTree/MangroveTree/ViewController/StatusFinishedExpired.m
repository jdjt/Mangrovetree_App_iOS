//
//  StatusFinishedExpired.m
//  mgmanager
//
//  Created by Sun Peng on 15/12/12.
//  Copyright © 2015年 Beijing Century Union. All rights reserved.
//

#import "StatusFinishedExpired.h"

@implementation StatusFinishedExpired

- (NSString*)statusName
{
    return @"呼叫任务完成（超时）";
}

- (NSString*)cancelButtonText
{
    return @"";
}

- (NSInteger)statusValue
{
    return STATUS_FINISH_EXPIRED;
}

@end
