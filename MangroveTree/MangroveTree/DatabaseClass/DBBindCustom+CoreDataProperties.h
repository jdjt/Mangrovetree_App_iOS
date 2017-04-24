//
//  DBBindCustom+CoreDataProperties.h
//  MangroveTree
//
//  Created by liuchao on 2017/4/24.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "DBBindCustom+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBBindCustom (CoreDataProperties)

+ (NSFetchRequest<DBBindCustom *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *customerId;
@property (nullable, nonatomic, copy) NSString *imAccount;
@property (nullable, nonatomic, copy) NSString *hotelCode;
@property (nullable, nonatomic, copy) NSString *hotelName;
@property (nullable, nonatomic, copy) NSString *servcieDiv;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *serviceBeginTime;
@property (nullable, nonatomic, copy) NSString *serviceEndTime;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *userAccount;
@property (nullable, nonatomic, copy) NSString *deviceId;
@property (nullable, nonatomic, copy) NSString *deviceToken;
@property (nullable, nonatomic, copy) NSString *deviceType;
@property (nullable, nonatomic, copy) NSString *roomCode;
@property (nullable, nonatomic, copy) NSString *roomDesc;
@property (nullable, nonatomic, copy) NSString *idNo;
@property (nullable, nonatomic, copy) NSString *checkInDate;
@property (nullable, nonatomic, copy) NSString *checkOutDate;
@property (nullable, nonatomic, retain) DBUserLogin *belongUser;

@end

NS_ASSUME_NONNULL_END
