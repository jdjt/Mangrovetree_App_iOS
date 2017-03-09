//
//  FMRouteManager.h
//  FMMapKit
//
//  Created by fengmap on 16/9/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//
#import <CoreGraphics/CoreGraphics.h>
#import "FMManager.h"

@class FMRoute;
@class FMRouteResult;

@interface FMRouteManager : FMManager
/**
 *  show route
 *
 *  @param route route
 */
- (void)showRouteOnMap:(FMRoute *)route;

/**
 *  hidden route
 *
 *  @param route route
 */
- (void)hiddenRouteOnMap:(FMRoute *)route;

/**
 *  根据route获取route信息
 *
 *  @param route route
 *
 *  @return route信息
 */
- (FMRouteResult *)getRouteResultByRoute:(FMRoute *)route;

/**
 *  放大路线上的图片标注物
 *
 *  @param route 路线
 *  @param index 图片下标
 */
- (void)zoomImageMarkerOnRoute:(FMRoute *)route index:(int)index size:(CGSize)imageMarkerSize;

@end
