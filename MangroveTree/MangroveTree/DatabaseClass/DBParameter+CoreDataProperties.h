//
//  DBParameter+CoreDataProperties.h
//  MangroveTree
//
//  Created by 罗禹 on 2017/3/8.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "DBParameter+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBParameter (CoreDataProperties)

+ (NSFetchRequest<DBParameter *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *blueKey;
@property (nullable, nonatomic, copy) NSString *deviceToken;
@property (nullable, nonatomic, copy) NSString *diviceId;
@property (nullable, nonatomic, copy) NSString *retOk;

@end

NS_ASSUME_NONNULL_END
