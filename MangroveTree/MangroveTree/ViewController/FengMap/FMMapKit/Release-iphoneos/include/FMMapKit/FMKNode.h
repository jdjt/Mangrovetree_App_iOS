//
//  FMKNode.h
//  FMMapKit
//
//  Created by FengMap on 15/5/25.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FMKGeometry.h"
/**
 * 地图节点基类，
 * 节点用于显示在地图上的额外添加物
 */
@interface FMKNode : NSObject

/**
 *  内部关联指针
 */
@property (nonatomic,assign)  long pointer;

/**
 *  元素的唯一标识
 */
@property (nonatomic,assign)  NSInteger nodeTag;


/**
 *  用户自定义附加属性
 */
@property (nonatomic,strong) NSDictionary*  attributes;

@end
