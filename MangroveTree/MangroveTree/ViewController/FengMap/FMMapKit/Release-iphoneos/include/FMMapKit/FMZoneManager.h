//
//  FMZoneManager.h
//  FMMapKit
//
//  Created by fengmap on 16/9/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMManager.h"

@class FMZone;

@interface FMZoneManager : FMManager

/**
 根据MAC地址获取区域

 @param macAddr MAC地址

 @return 所在区域
 */
- (FMZone *)getCurrentZone;

/**
 显示相应区域

 @param zone 区域
 */
- (void)showZoneOnMap:(FMZone *)zone;

/**
 隐藏相应区域

 @param zone 区域
 */
- (void)hiddenZoneOnMap:(FMZone *)zone;

@end
