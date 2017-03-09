//
//  FMKBubbleView.h
//  FMMapKit
//
//  Created by fengmap on 16/7/25.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMKGeometry.h"
#import "FMKMapView.h"

@interface FMKBubbleView : UIView

///添加的气泡所在的地图位置
@property (nonatomic, assign) FMKGeoCoord coord;

/**
 *  初始化气泡视图
 *
 *  @param customView 自定义控件
 *
 *  @return 气泡对象
 */
- (instancetype)initWithCustomView:(UIView *)customView;

/**
 *  添加气泡
 *
 *  @param mapView 气泡所在的地图
 *  @param zType   气泡所在坐标的Z值  表示气泡在地面、模型、标注物等之上
 */
- (void)addBubbleViewOnMapView:(FMKMapView *)mapView mapCoordZType:(FMKMapCoordZType)zType;

@end
