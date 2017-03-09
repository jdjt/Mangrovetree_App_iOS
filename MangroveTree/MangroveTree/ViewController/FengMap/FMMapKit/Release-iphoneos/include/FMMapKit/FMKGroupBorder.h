//
//  FMKGroupBorder.h
//  FMMapKit
//
//  Created by fengmap on 16/1/12.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMKHeatBorder.h"

@interface FMKGroupBorder : FMKHeatBorder

///内部关联指针
@property (nonatomic,assign) long pointer;

///热力图所在楼层ID
@property (nonatomic,copy)NSString * groupID;

/**
 *  热力图边界
 *
 *  @param groupID 热力图楼层ID
 *
 *  @return 热力图边界对象
 */
- (instancetype)initWithGroupID:(NSString *)groupID;

@end
