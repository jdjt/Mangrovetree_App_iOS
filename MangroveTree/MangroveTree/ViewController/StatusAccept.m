//
//  StatusAccept.m
//  mgmanager
//
//  Created by Sun Peng on 15/12/12.
//  Copyright © 2015年 Beijing Century Union. All rights reserved.
//

#import "StatusAccept.h"

@implementation StatusAccept

- (NSString*)statusName
{
    return @"已取消";
}

- (NSString*)cancelButtonText
{
    return @"";
}

- (NSInteger)statusValue
{
    return STATUS_ACCEPT;
}

@end
