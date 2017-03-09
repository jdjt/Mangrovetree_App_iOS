//
//  DevicePositionInfo.h
//  StaticModelDemo
//
//  Created by fengmap on 16/5/20.
//  Copyright © 2016年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMKGeometry.h"
@interface DevicePositionInfo : NSObject

@property (nonatomic,strong)NSNumber * CoordinatesId;
@property (nonatomic,copy)NSString * CoordinatesName;
@property (nonatomic,strong)NSNumber * ErrorCode;
@property (nonatomic,copy)NSString * ErrorText;
@property (nonatomic,copy)NSString * HostExternalInfo;
@property (nonatomic,copy)NSString * HostExternalId;
@property (nonatomic,strong)NSArray * HostGroupIds;
@property (nonatomic,strong)NSNumber *  HostId;
@property (nonatomic,strong)NSNumber *  HostStatusId;
@property (nonatomic,strong)NSNumber *  MapId;
@property (nonatomic,strong)NSNumber *  TagId;
@property (nonatomic,strong)NSNumber *  X;
@property (nonatomic,strong)NSNumber *  Y;
@property (nonatomic,copy)NSString * HostName;
@property (nonatomic,copy)NSString * SerialNo;
@property (nonatomic,copy)NSString * TagMac;
@property (nonatomic,copy)NSString * TagName;
@property (nonatomic,copy)NSString * postionUpdateTime;
@property (nonatomic,assign)BOOL IsAreaWarning;
@property (nonatomic,assign)BOOL IsBeltBroken;
@property (nonatomic,assign)BOOL IsButtonPress;
@property (nonatomic,assign)BOOL IsDisappeared;
@property (nonatomic,assign)BOOL IsLowBattery;
@property (nonatomic,assign)BOOL IsMove2Still;
@property (nonatomic,assign)BOOL IsReset;
@property (nonatomic,assign)BOOL IsStill2Move;
@property (nonatomic,assign)BOOL Success;
@property (nonatomic,assign)NSNumber * MaxRssi;//wifi信号强度
@property (nonatomic,assign)NSNumber * MaxRssiAP_MapID;//地图ID
@property (nonatomic,copy)NSString * MaxRssiAPMac;//MAC地址
@property (nonatomic,assign)CGPoint position;
@property (nonatomic,assign)FMKMapPoint uCoord;
@property (nonatomic,assign)FMKMapCoord mapCoord;//转化后的地图坐标
@end
