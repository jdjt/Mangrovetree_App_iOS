//
//  FMKGroup.h
//  FMMapKit
//
//  Created by fengmap on 16/1/12.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class FMKHeatMap;
@class FMKMapView;
@class FMKGroupInfo;

@interface FMKGroup : NSObject

///内部关联指针
@property (nonatomic,assign) long pointer;

///楼层透明度
@property (nonatomic,assign) CGFloat alpha;

///楼层隐藏属性
@property (nonatomic,assign) BOOL hidden;

///楼层ID
@property (nonatomic,copy) NSString * groupID;

///楼层信息
@property (nonatomic,strong) FMKGroupInfo * groupInfo;



/**
 *  初始化楼层 不支持用户创建楼层 只能通过map节点获取楼层
 *
 *  @param groupID 楼层ID
 *
 *  @return FMKGroup对象
 */
- (instancetype)initWithGroupID:(NSString *)groupID;

/**
 *  应用热力图
 *
 *  @param heatMap  热力图
 */
- (void)applyHeatMap:(FMKHeatMap *)heatMap;

/**
 *  清除热力图
 *
 *  @param mapView 热力图所在的地图
 */
- (void)removeHeatMap:(FMKMapView * )mapView;

/**
 *  楼层偏移的改变量
 *
 *  @param X X轴偏移改变量
 *  @param Y Y轴偏移改变量
 *  @param Z Z轴偏移改变量
 */
- (void)setGroupCoordinateByChangedWithX:(float)X withY:(float)Y withZ:(float)Z;

/**
 *  设置楼层的偏移量
 *
 *  @param X X轴偏移量
 *  @param Y Y轴偏移量
 *  @param Z Z轴偏移量
 */
- (void)setTranslateX:(float)X withTranslateY:(float)Y withTranslateZ:(float)Z;

@end
