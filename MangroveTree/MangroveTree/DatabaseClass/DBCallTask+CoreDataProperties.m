//
//  DBCallTask+CoreDataProperties.m
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/5/6.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "DBCallTask+CoreDataProperties.h"

@implementation DBCallTask (CoreDataProperties)

+ (NSFetchRequest<DBCallTask *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBCallTask"];
}

@dynamic acceptTime;
@dynamic areaCode;
@dynamic areaName;
@dynamic cancelCode;
@dynamic cancelDesc;
@dynamic cancelDetail;
@dynamic cancelPoint;
@dynamic cancelTime;
@dynamic cImAccount;
@dynamic customerId;
@dynamic finishEndTime;
@dynamic finishTime;
@dynamic hotelCode;
@dynamic nowDate;
@dynamic produceTime;
@dynamic scoreMod;
@dynamic scoreTime;
@dynamic scoreVal;
@dynamic taskCode;
@dynamic taskContent;
@dynamic taskStatus;
@dynamic userDeviceId;
@dynamic waiterDeviceId;
@dynamic waiterEndTime;
@dynamic waiterId;
@dynamic waiteTime;
@dynamic wImAccount;
@dynamic waiterName;
@dynamic belongUser;

@end
