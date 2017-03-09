//
//  FMKTextLayer.h
//  FMMapKit
//
//  Created by fengmap on 15/12/29.
//  Copyright © 2015年 FengMap. All rights reserved.
//

#import "FMKLayer.h"

@class FMKTextMarker;

typedef NS_ENUM(NSInteger, FMKTextCoverCalcMode)
{
	FMKTEXT_COVERCALC_NONE=0,
	FMKTEXT_COVERCALC_NODEADDSEQUENCE
};

@interface FMKTextLayer : FMKLayer

///文本图层所在楼层ID
@property (nonatomic,copy) NSString * groupID;

/**
 文本避让计算模式
 */
@property (nonatomic, assign) FMKTextCoverCalcMode textCoverCalcMode;

/**
 *  初始化文本图层(在同一楼层下可创建多个文本图层)
 *
 *  @param groupID 文本图层所在楼层
 *
 *  @return 文本图层
 */
- (instancetype)initWithGroupID:(NSString *)groupID;

/**
 *  添加文本标注物
 *
 *  @param textMarker 文本标注物
 */
- (void)addTextMarker:(FMKTextMarker *)textMarker;

/**
 *  通过tag获取文本标注物
 *
 *  @param tag 文本标注物的tag
 *
 *  @return 对应tag的文本标注物
 */
- (FMKTextMarker *)textMarkerWithTag:(NSInteger)tag;

/**
 *  删除文本标注物
 *
 *  @param textMarker 文本标注物
 */
- (void)removeTextMarker:(FMKTextMarker *)textMarker;

/**
 *  删除该图层下的所有文本标注物
 */
- (void)removeAllTextMarker;

@end
