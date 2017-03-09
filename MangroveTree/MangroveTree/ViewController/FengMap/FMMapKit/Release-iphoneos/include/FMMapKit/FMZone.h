//
//  FMZone.h
//  FMMapKit
//
//  Created by fengmap on 16/9/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMBaseModel.h"

@interface FMZone : FMBaseModel

@property (nonatomic, copy) NSString * zone_code;		//区域唯一编码
@property (nonatomic, copy) NSString * zone_name;		//区域名称
@property (nonatomic, assign) int zone_type;			//区域type
@property (nonatomic, strong) NSArray * zone_coords;	//封闭区域坐标

@end
