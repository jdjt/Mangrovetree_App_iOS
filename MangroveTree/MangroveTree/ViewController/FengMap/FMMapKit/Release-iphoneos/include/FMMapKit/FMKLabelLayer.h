//
//  FMKLabelLayer.h
//  FMMapKit
//
//  Created by fengmap on 16/3/7.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMKLayer.h"

@interface FMKLabelLayer : FMKLayer
/**
 *  初始化label层
 *
 *  @param groupID label所在楼层
 *
 *  @return label管理层对象
 */
- (instancetype)initWithGroupID:(NSString *)groupID;

/**
 *  label所在楼层
 */
@property(readonly)NSString * groupID;

@end
