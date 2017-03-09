//
//  FMKExtentLayer.h
//  FMMapKit
//
//  Created by fengmap on 15/12/24.
//  Copyright © 2015年 Fengmap. All rights reserved.
//

#import "FMKLayer.h"

@interface FMKExtentLayer : FMKLayer
/**
 *  初始化底图层
 *
 *  @param groupID 所在楼层ID
 *
 *  @return 底图层对象
 */
- (instancetype)initWithGroupID:(NSString *)groupID;

/**
 *  所在楼层ID
 */
@property(readonly)NSString * groupID;

@end
