//
//  FMActivity.h
//  FMMapKit
//
//  Created by fengmap on 16/9/18.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMBaseModel.h"

@interface FMActivity : FMBaseModel

@property (nonatomic, copy) NSString * activity_code;		//业态编码
@property (nonatomic, copy) NSString * zone_code;			//业态所在区域编码
@property (nonatomic, copy) NSString * activity_name;		//业态Name
@property (nonatomic, copy) NSString * fmap_fid;			//业态所在fengmap模型唯一编码
@property (nonatomic, assign) int mapID;//地图ID
@property (nonatomic, copy) NSString * groupID;//楼层ID
@property (nonatomic, assign) FMKMapPoint fmap_position;	//业态所在模型fengmap坐标

@end
