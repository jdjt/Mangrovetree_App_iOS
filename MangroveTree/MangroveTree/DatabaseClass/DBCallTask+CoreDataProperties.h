//
//  DBCallTask+CoreDataProperties.h
//  MangroveTree
//
//  Created by 罗禹 on 2017/3/8.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "DBCallTask+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBCallTask (CoreDataProperties)

+ (NSFetchRequest<DBCallTask *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *acceptStatus;
@property (nullable, nonatomic, copy) NSString *cancelTime;
@property (nullable, nonatomic, copy) NSString *category;
@property (nullable, nonatomic, copy) NSString *confirmState;
@property (nullable, nonatomic, copy) NSString *deviceToken;
@property (nullable, nonatomic, copy) NSString *diviceId;
@property (nullable, nonatomic, copy) NSString *drOrderNo;
@property (nullable, nonatomic, copy) NSString *guestUserID;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, copy) NSString *locationArea;
@property (nullable, nonatomic, copy) NSString *locationDesc;
@property (nullable, nonatomic, copy) NSString *messageInfo;
@property (nullable, nonatomic, copy) NSString *orderTime;
@property (nullable, nonatomic, copy) NSString *patternInfo;
@property (nullable, nonatomic, copy) NSString *priority;
@property (nullable, nonatomic, copy) NSString *remark;
@property (nullable, nonatomic, copy) NSString *score;
@property (nullable, nonatomic, copy) NSString *sendTime;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *taskCode;
@property (nullable, nonatomic, copy) NSString *timelimit;
@property (nullable, nonatomic, copy) NSString *waiterAppKey;
@property (nullable, nonatomic, copy) NSString *waiterUserID;
@property (nullable, nonatomic, copy) NSString *workAcceptTime;
@property (nullable, nonatomic, copy) NSString *workDeviceId;
@property (nullable, nonatomic, copy) NSString *workDeviceToken;
@property (nullable, nonatomic, copy) NSString *workFinishTime;
@property (nullable, nonatomic, copy) NSString *workLocation;
@property (nullable, nonatomic, copy) NSString *workNum;

@end

NS_ASSUME_NONNULL_END
