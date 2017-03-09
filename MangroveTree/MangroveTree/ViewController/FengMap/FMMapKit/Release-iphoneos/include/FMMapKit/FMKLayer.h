//
//  FMKLayer.h
//  FMMapKit
//
//  Created by FengMap on 15/6/2.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FMKGeometry.h"
#import "FMKLayerDelegate.h"



/**
 *  地图层节点基类
 */
@interface FMKLayer : NSObject <FMKLayerDelegate>

/**
 *  内部关联指针
 */
@property (nonatomic,assign)  long pointer;

/**
 *  层标识,用于层的唯一标识
 */
@property (nonatomic,assign) NSInteger layerTag;

/**
 *  图层代理
 */
@property (nonatomic,weak) id<FMKLayerDelegate> delegate;

/**
 *  图层的隐藏属性
 */
@property (nonatomic,assign) BOOL hidden;

/**
 *  图层下的所有子节点
 */
@property (nonatomic,readonly) NSArray*  subNodes;

/**
 *  图层节点透明度
 */
@property (nonatomic,assign) float alpha;

@end

