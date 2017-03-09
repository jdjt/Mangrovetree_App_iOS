//
//  DBParameter+CoreDataProperties.m
//  MangroveTree
//
//  Created by 罗禹 on 2017/3/8.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "DBParameter+CoreDataProperties.h"

@implementation DBParameter (CoreDataProperties)

+ (NSFetchRequest<DBParameter *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBParameter"];
}

@dynamic blueKey;
@dynamic deviceToken;
@dynamic diviceId;
@dynamic retOk;

@end
