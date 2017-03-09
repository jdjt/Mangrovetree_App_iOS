//
//  FMKLayerGroup.h
//  FMMapKit
//
//  Created by FengMap on 15/7/20.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  地图的每一个楼层对应一个layerGroup
 */
@interface FMKGroupInfo : NSObject

/**
 *  图层组id(楼层ID)
 */
@property (nonatomic,copy) NSString* gid;
/**
 *  楼层名称
 */
@property (nonatomic,copy) NSString* name;
/**
 *  别名
 */
@property (nonatomic,copy) NSString* alias;
/**
 *  高度
 */
@property (nonatomic,assign) float   height;
/**
 *  描述
 */
@property (nonatomic,copy) NSString* desc;


@end
