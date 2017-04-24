//
//  DBUserLogin+CoreDataProperties.h
//  MangroveTree
//
//  Created by liuchao on 2017/4/24.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "DBUserLogin+CoreDataClass.h"
#import "DBBindCustom+CoreDataClass.h"
#import "DBCallTask+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBUserLogin (CoreDataProperties)

+ (NSFetchRequest<DBUserLogin *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *account;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *idNo;
@property (nullable, nonatomic, copy) NSString *idType;
@property (nullable, nonatomic, copy) NSString *isLogIn;
@property (nullable, nonatomic, copy) NSString *isShowUnPay;
@property (nullable, nonatomic, copy) NSString *membername;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, copy) NSString *msgs;
@property (nullable, nonatomic, copy) NSString *nickname;
@property (nullable, nonatomic, copy) NSString *openBalabce;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *realName;
@property (nullable, nonatomic, copy) NSString *sex;
@property (nullable, nonatomic, copy) NSString *stste;
@property (nullable, nonatomic, copy) NSString *ticker;
@property (nullable, nonatomic, retain) DBBindCustom *hasCustomBind;
@property (nullable, nonatomic, retain) NSSet<DBCallTask *> *hasTask;

@end

@interface DBUserLogin (CoreDataGeneratedAccessors)

- (void)addHasTaskObject:(DBCallTask *)value;
- (void)removeHasTaskObject:(DBCallTask *)value;
- (void)addHasTask:(NSSet<DBCallTask *> *)values;
- (void)removeHasTask:(NSSet<DBCallTask *> *)values;

@end

NS_ASSUME_NONNULL_END
