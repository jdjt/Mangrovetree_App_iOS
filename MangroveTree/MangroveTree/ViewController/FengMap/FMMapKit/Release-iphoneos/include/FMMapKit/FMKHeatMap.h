//
//  FMKHeatMap.h
//  FMMapKit
//
//  Created by fengmap on 15/12/25.
//  Copyright © 2015年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMKHeatBorder;
@class FMKMapView;

@interface FMKHeatMap : NSObject

/**
 *  初始化FMKHeatMap对象
 *
 *  @param heatFactors 热力图位置因子集合
 *  @param heatColors  热力图颜色因子集合
 *  @param mapView     需要应用的地图视图
 *
 *  @return FMKHeatMap对象
 */
- (instancetype)initWithHeatFactors:(NSArray*)heatFactors
                        withHeatColors:(NSArray*)heatColors
                        withMapView:(FMKMapView *)mapView;
/**
 *  内部关联指针
 */
@property (nonatomic,assign)long pointer;

///热力图所在地图
@property (nonatomic,strong)FMKMapView * mapView;

/**
 *  添加热力图边界值
 *
 *  @param border 热力图边界对象
 */
- (void)addBorder:(FMKHeatBorder * )heatBorder;

/**
 *  生成热力图
 */
- (void)generate;

@end
