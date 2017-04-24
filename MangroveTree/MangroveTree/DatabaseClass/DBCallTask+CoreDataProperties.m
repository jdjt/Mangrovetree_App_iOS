//
//  DBCallTask+CoreDataProperties.m
//  MangroveTree
//
//  Created by liuchao on 2017/4/24.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "DBCallTask+CoreDataProperties.h"

@implementation DBCallTask (CoreDataProperties)

+ (NSFetchRequest<DBCallTask *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBCallTask"];
}

@dynamic taskCode;
@dynamic taskContent;
@dynamic taskStatus;
@dynamic hotelCode;
@dynamic areaCode;
@dynamic areaName;
@dynamic cancelDetail;
@dynamic cancelTime;
@dynamic cancelPoint;
@dynamic cancelCode;
@dynamic cancelDesc;
@dynamic scoreTime;
@dynamic scoreMod;
@dynamic scoreVal;
@dynamic customerId;
@dynamic cImAccount;
@dynamic waiterId;
@dynamic wImAccount;
@dynamic nowDate;
@dynamic waiteTime;
@dynamic waiterEndTime;
@dynamic acceptTime;
@dynamic finishTime;
@dynamic finishEndTime;
@dynamic waiterDeviceId;
@dynamic userDeviceId;
@dynamic belongUser;

@end
