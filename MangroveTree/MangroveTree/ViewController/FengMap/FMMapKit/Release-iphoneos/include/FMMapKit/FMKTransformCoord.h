//
//  FMKTransformCoord.h
//  FMMapKit
//
//  Created by fengmap on 16/8/17.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FMKGeometry.h"

typedef struct FMKResult
{
	FMKMapPoint mapPoint;
	int groupID;
	const char * resultStr;
	
}FMKResult;

@interface FMKTransformCoord : NSObject

/**
 *  84坐标转fengmap坐标
 *
 *  @param lonLat 经纬度
 *
 *  @return fengmap坐标
 */
+ (FMKMapPoint )lonLat2Mercator:(CLLocationCoordinate2D) lonLat;

/**
 *  初始化优频定位转换工具类
 *
 *  @param path json路径
 *
 *  @return 工具类
 */
- (instancetype)initWithPath:(NSString *)path;

/**
 *  转化坐标
 *
 *  @param imageID  图片ID
 *  @param mapPoint 定位返回坐标
 *
 *  @return fengmap坐标
 */
- (FMKResult)transformUCoordToFengMapCoordByImageID:(NSString * )imageID uCoord:(FMKMapPoint)mapPoint;

@end
