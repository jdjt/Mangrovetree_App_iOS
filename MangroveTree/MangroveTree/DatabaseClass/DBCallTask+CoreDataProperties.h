//
//  DBCallTask+CoreDataProperties.h
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/5/6.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "DBCallTask+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBCallTask (CoreDataProperties)

+ (NSFetchRequest<DBCallTask *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *acceptTime;
@property (nullable, nonatomic, copy) NSString *areaCode;
@property (nullable, nonatomic, copy) NSString *areaName;
@property (nullable, nonatomic, copy) NSString *cancelCode;
@property (nullable, nonatomic, copy) NSString *cancelDesc;
@property (nullable, nonatomic, copy) NSString *cancelDetail;
@property (nullable, nonatomic, copy) NSString *cancelPoint;
@property (nullable, nonatomic, copy) NSString *cancelTime;
@property (nullable, nonatomic, copy) NSString *cImAccount;
@property (nullable, nonatomic, copy) NSString *customerId;
@property (nullable, nonatomic, copy) NSString *finishEndTime;
@property (nullable, nonatomic, copy) NSString *finishTime;
@property (nullable, nonatomic, copy) NSString *hotelCode;
@property (nullable, nonatomic, copy) NSString *nowDate;
@property (nullable, nonatomic, copy) NSString *produceTime;
@property (nullable, nonatomic, copy) NSString *scoreMod;
@property (nullable, nonatomic, copy) NSString *scoreTime;
@property (nullable, nonatomic, copy) NSString *scoreVal;
@property (nullable, nonatomic, copy) NSString *taskCode;
@property (nullable, nonatomic, copy) NSString *taskContent;
@property (nullable, nonatomic, copy) NSString *taskStatus;
@property (nullable, nonatomic, copy) NSString *userDeviceId;
@property (nullable, nonatomic, copy) NSString *waiterDeviceId;
@property (nullable, nonatomic, copy) NSString *waiterEndTime;
@property (nullable, nonatomic, copy) NSString *waiterId;
@property (nullable, nonatomic, copy) NSString *waiteTime;
@property (nullable, nonatomic, copy) NSString *wImAccount;
@property (nullable, nonatomic, copy) NSString *waiterName;
@property (nullable, nonatomic, retain) DBUserLogin *belongUser;

@end

NS_ASSUME_NONNULL_END
