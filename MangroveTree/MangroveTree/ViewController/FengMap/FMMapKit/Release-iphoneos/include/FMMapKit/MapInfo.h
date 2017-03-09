//
//  MapInfo.h
//  StaticModelDemo
//
//  Created by fengmap on 16/5/19.
//  Copyright © 2016年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapInfo : NSObject

@property (nonatomic,strong)NSNumber * FacilityEastWest;
@property (nonatomic,strong)NSNumber * FacilitySouthNorth;
@property (nonatomic,strong)NSNumber * Id;
@property (nonatomic,strong)NSNumber * MapHeight;
@property (nonatomic,strong)NSNumber * MapWidth;
@property (nonatomic,strong)NSNumber * Scale_X;
@property (nonatomic,strong)NSNumber * Scale_Y;

@property (nonatomic,assign)BOOL IsDisabled;
@property (nonatomic,copy)NSString * MapFileName;
@property (nonatomic,copy)NSString * MapName;
@property (nonatomic,copy)NSString * WriteTime;


@end
