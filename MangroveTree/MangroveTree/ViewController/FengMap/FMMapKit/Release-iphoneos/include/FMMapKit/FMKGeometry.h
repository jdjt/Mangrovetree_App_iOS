//
//  FMGeometry.h
//  FMMapKit
//
//  Created by FengMap on 15/4/28.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
    !@brief 蜂鸟视图点,
    该点为地图数据点，
    通过地图数据取得
 */

typedef double  FMKDegrees;
typedef int     FMKMapStorey;

//蜂鸟投影坐标点
struct FMKMapPoint
{
    FMKDegrees x;
    FMKDegrees y;
};
typedef struct FMKMapPoint FMKMapPoint;

inline static FMKMapPoint FMKMapPointMake(FMKDegrees x,FMKDegrees y)
{
    FMKMapPoint coord;
    coord.x = x;
    coord.y = y;
    return coord;
}

inline static const FMKMapPoint FMKMapPointZero(void)
{
    return FMKMapPointMake(0, 0);
}

inline static NSString* NSStringFromFMKMapPoint(FMKMapPoint coord)
{
    return [NSString stringWithFormat:@"%f %f",coord.x,coord.y];
}

//蜂鸟地理楼层坐标点
struct FMKGeoCoord
{    
    FMKMapStorey storey;        //楼层
    FMKMapPoint    mapPoint;   //投影坐标
};
typedef struct FMKGeoCoord FMKGeoCoord;

inline static FMKGeoCoord FMKGeoCoordMake(FMKMapStorey storey,FMKMapPoint coord)
{
    FMKGeoCoord geoCoord;
    geoCoord.mapPoint  = coord;
    geoCoord.storey    = storey;
    return geoCoord;
}

inline static const FMKGeoCoord FMKGeoCoordZero(void)
{
    return FMKGeoCoordMake(0, FMKMapPointZero());
}

inline static NSString* NSStringFromFMKGeoCoord(FMKGeoCoord geoCoord)
{
    return [NSString stringWithFormat:@"%d %f %f",geoCoord.storey,geoCoord.mapPoint.x,geoCoord.mapPoint.y];
}

typedef  struct FMKMapCoord
{
	int mapID;
	FMKGeoCoord coord;
	
}FMKMapCoord;

inline static FMKMapCoord FMKMapCoordMake(int mapID, FMKGeoCoord coord)
{
	FMKMapCoord mapCoord;
	mapCoord.mapID = mapID;
	mapCoord.coord = coord;
	return mapCoord;
}

inline static NSString* NSStringFromFMKMapCoord(FMKMapCoord mapCoord)
{
	return [NSString stringWithFormat:@"%d %d %f %f",mapCoord.mapID,mapCoord.coord.storey,mapCoord.coord.mapPoint.x,mapCoord.coord.mapPoint.y];
}

inline static const FMKMapCoord FMKMapCoordZero(void)
{
	return FMKMapCoordMake(0, FMKGeoCoordZero());
}

@interface NSValue (FMKValue)

+ (NSValue *)valueWithFMKMapPoint:(FMKMapPoint)mapPoint;
+ (NSValue *)valueWithFMKGeoCoord:(FMKGeoCoord)geoCoord;

- (FMKMapPoint)FMKMapPointValue;
- (FMKGeoCoord)FMKGeoCoordValue;

@end








