//
//  QueryDBModel.h
//  mgmanager
//
//  Created by fengmap on 16/8/24.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryDBModel : NSObject

//数据库对应模型
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * mid;
@property (nonatomic, copy) NSString * fid;
@property (nonatomic, copy) NSString * ename;
@property (nonatomic, copy) NSString * typeName;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * subTypeName;
@property (nonatomic, copy) NSString * activityCode;

@property (nonatomic, assign) int rowid;
@property (nonatomic, assign) int gid;
@property (nonatomic, assign) int ftype;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) float z;

@end
