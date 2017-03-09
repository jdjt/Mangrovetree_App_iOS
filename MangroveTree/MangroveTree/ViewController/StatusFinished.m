//
//  StatusFinished.m
//  mgmanager
//
//  Created by Sun Peng on 15/12/12.
//  Copyright © 2015年 Beijing Century Union. All rights reserved.
//

#import "StatusFinished.h"

@implementation StatusFinished

- (NSString*)statusName
{
    return @"呼叫任务完成";
}

- (NSString*)cancelButtonText
{
    return @"";
}

- (NSInteger)statusValue
{
    return STATUS_FINISH;
}

@end
