//
//  DBCallTask+CoreDataProperties.m
//  MangroveTree
//
//  Created by 罗禹 on 2017/3/8.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "DBCallTask+CoreDataProperties.h"

@implementation DBCallTask (CoreDataProperties)

+ (NSFetchRequest<DBCallTask *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBCallTask"];
}

@dynamic acceptStatus;
@dynamic cancelTime;
@dynamic category;
@dynamic confirmState;
@dynamic deviceToken;
@dynamic diviceId;
@dynamic drOrderNo;
@dynamic guestUserID;
@dynamic location;
@dynamic locationArea;
@dynamic locationDesc;
@dynamic messageInfo;
@dynamic orderTime;
@dynamic patternInfo;
@dynamic priority;
@dynamic remark;
@dynamic score;
@dynamic sendTime;
@dynamic status;
@dynamic taskCode;
@dynamic timelimit;
@dynamic waiterAppKey;
@dynamic waiterUserID;
@dynamic workAcceptTime;
@dynamic workDeviceId;
@dynamic workDeviceToken;
@dynamic workFinishTime;
@dynamic workLocation;
@dynamic workNum;

@end
