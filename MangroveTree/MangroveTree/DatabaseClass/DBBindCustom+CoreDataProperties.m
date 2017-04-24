//
//  DBBindCustom+CoreDataProperties.m
//  MangroveTree
//
//  Created by liuchao on 2017/4/24.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "DBBindCustom+CoreDataProperties.h"

@implementation DBBindCustom (CoreDataProperties)

+ (NSFetchRequest<DBBindCustom *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBBindCustom"];
}

@dynamic customerId;
@dynamic imAccount;
@dynamic hotelCode;
@dynamic hotelName;
@dynamic servcieDiv;
@dynamic name;
@dynamic phone;
@dynamic serviceBeginTime;
@dynamic serviceEndTime;
@dynamic userId;
@dynamic userAccount;
@dynamic deviceId;
@dynamic deviceToken;
@dynamic deviceType;
@dynamic roomCode;
@dynamic roomDesc;
@dynamic idNo;
@dynamic checkInDate;
@dynamic checkOutDate;
@dynamic belongUser;

@end
