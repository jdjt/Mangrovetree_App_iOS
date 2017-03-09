//
//  FMKSearchObj.h
//  FMMapKit
//
//  Created by FengMap on 15/8/20.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKGeometry.h"

@interface FMKSearchRequest : NSObject
@end

@interface FMKSearchResult : NSObject
@end

#pragma model
/**
 *  模型请求体
 */
@interface FMKModelSearchRequest : FMKSearchRequest

@property (nonatomic,strong) NSArray*  groupIDs;  // 要查询的楼层，默认为全楼层
@property (nonatomic,copy)   NSString* keywords; // 查询关键字，多个关键字用“|”分割
@property (nonatomic,copy)   NSString* fid;      // 返回同一fid的模型,多个关键字用“|”分割
@property (nonatomic,copy)   NSString* type;     // 返回同一类型的模型,多个关键字用“|”分割

@property (nonatomic, assign) FMKMapPoint mapPoint;//查询这个点包含在哪个模型内

@end

/**
 *  模型请求结果
 */
@interface FMKModelSearchResult : FMKSearchResult

@property (nonatomic,copy)      NSString*   groupID;      //所在楼层
@property (nonatomic,copy)      NSString*   groupName;    //楼层名称
@property (nonatomic,copy)      NSString*   eid;          //eid
@property (nonatomic,copy)      NSString*   fid;          //模型fid
@property (nonatomic,copy)      NSString*   name;         //名称
@property (nonatomic,copy)      NSString*   ename;        //英文名称
@property (nonatomic,copy)      NSString*   type;         //模型类型
@property (nonatomic,assign)    FMKMapPoint centerCoord;  //中心点地理坐标
@property (nonatomic,assign)  float       height;       //模型高度


@end

#pragma externalModel
/**
 *  外部模型请求体
 */
@interface FMKExternalModelSearchRequest : FMKSearchRequest

@property (nonatomic,strong)NSArray * groupIDs;
@property (nonatomic,copy)NSString * fid;
@property (nonatomic,copy)NSString * keywords;
@property (nonatomic,copy)NSString * type;
@property (nonatomic,strong) NSArray * mapPoints;

@end

@interface FMKExternalModelSearchResult : FMKSearchResult

@property (nonatomic,copy)      NSString*   groupID;      //所在楼层
@property (nonatomic,copy)      NSString*   groupName;    //楼层名称
@property (nonatomic,copy)      NSString*   eid;          //gid
@property (nonatomic,copy)      NSString*   name;         //名称
@property (nonatomic,copy)      NSString*   ename;        //英文名称
@property (nonatomic,copy)      NSString*   type;         //设施类型
@property (nonatomic,copy)      NSString*   desc;         //设施描述
@property (nonatomic,copy)      NSString*   fid;
@property (nonatomic,assign)    FMKMapPoint centerCoord;  //中心点地理坐标

@end

#pragma facility

/**
 *  公共设施请求体
 */
@interface FMKFacilitySearchRequest : FMKSearchRequest

@property (nonatomic,strong) NSArray*  groupIDs;   // 要查询的楼层，默认为全楼层
@property (nonatomic,copy)   NSString* type;      //公共设施类型，多个关键字用“|”分割

@end

/**
 *  公共设施请求结果
 */
@interface FMKFacilitySearchResult : FMKSearchResult

@property (nonatomic,copy)      NSString*   groupID;      //所在楼层
@property (nonatomic,copy)      NSString*   groupName;    //楼层名称
@property (nonatomic,copy)      NSString*   gid;          //gid
@property (nonatomic,copy)      NSString*   name;         //名称
@property (nonatomic,copy)      NSString*   ename;        //英文名称
@property (nonatomic,copy)      NSString*   type;         //设施类型
@property (nonatomic,copy)      NSString*   desc;         //设施描述
@property (nonatomic,assign)    FMKMapPoint centerCoord;  //中心点地理坐标

@end






