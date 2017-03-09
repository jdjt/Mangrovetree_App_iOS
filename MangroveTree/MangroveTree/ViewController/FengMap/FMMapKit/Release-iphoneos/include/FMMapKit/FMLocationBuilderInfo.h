//
//  FMLocationBuilderInfo.h
//  FMMapKit
//
//  Created by fengmap on 16/9/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMBaseModel.h"

@interface FMLocationBuilderInfo : FMBaseModel

@property (nonatomic, copy) NSString * loc_mac;//MAC地址

/**
 *	图标Name 此图标需在FMBundle中的Resources文件夹下
 */
@property (nonatomic, copy) NSString * loc_icon;
@property (nonatomic, copy) NSString * loc_desc;//标注物附加信息


@end
