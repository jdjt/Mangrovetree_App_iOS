//
//  FMKExternalModelLayer.h
//  FMMapKit
//
//  Created by fengmap on 16/6/1.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMKLayer.h"
@class FMKExternalModel;

@interface FMKExternalModelLayer : FMKLayer

@property (nonatomic,copy)NSString * groupID;

- (instancetype)initWithGroupID:(NSString *)groupID;

/**
 *  通过fid查找外部模型
 *
 *  @param fid 外部模型的fid
 *
 *  @return 获取外部模型
 */
- (FMKExternalModel *)queryExternalModelByFid:(NSString *)fid;

@end
