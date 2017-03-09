//
//  DBUserLogin+CoreDataProperties.m
//  MangroveTree
//
//  Created by 罗禹 on 2017/3/7.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "DBUserLogin+CoreDataProperties.h"

@implementation DBUserLogin (CoreDataProperties)

+ (NSFetchRequest<DBUserLogin *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBUserLogin"];
}

@dynamic account;
@dynamic email;
@dynamic idNo;
@dynamic idType;
@dynamic isLogIn;
@dynamic isShowUnPay;
@dynamic membername;
@dynamic mobile;
@dynamic msgs;
@dynamic nickname;
@dynamic openBalabce;
@dynamic password;
@dynamic realName;
@dynamic sex;
@dynamic stste;
@dynamic ticker;

@end
