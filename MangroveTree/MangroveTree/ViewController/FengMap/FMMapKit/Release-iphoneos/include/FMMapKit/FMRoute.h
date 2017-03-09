//
//  FMRoute.h
//  FMMapKit
//
//  Created by fengmap on 16/9/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMBaseModel.h"

@interface FMRoute : FMBaseModel

@property (nonatomic, copy) NSString * route_code;				//路线编码
@property (nonatomic, copy) NSString * route_name;				//路线名称
@property (nonatomic, strong) NSArray * activity_code_list;		//关联业态唯一编码列表
@property (nonatomic, assign) int route_type;					//路线类型
@property (nonatomic, strong) NSArray * route_points;           //路线坐标点

@end
