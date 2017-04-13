//
//  FMActivityManager.h
//  FMMapKit
//
//  Created by fengmap on 16/9/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMManager.h"

@class FMActivity;
@class FMRoute;

@interface FMActivityManager : FMManager

/**
 *  高亮poi
 *
 *  @param activity poi
 */
- (void)highlightActivity:(FMActivity *)activity;

/**
 *  Show pois
 *
 *  @param activeties pois
 */
- (void)showActivityListOnMap:(NSArray *)activities;
/**
 *  hidden pois
 *
 *  @param activities pois
 */
- (void)hiddenActivityListOnMap:(NSArray *)activities;

/**
 *  恢复初始状态
 */
- (void)showAllOnMap;


@end
