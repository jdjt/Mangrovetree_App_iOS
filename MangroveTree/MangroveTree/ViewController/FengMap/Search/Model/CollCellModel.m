//
//  CollCellModel.m
//  FeiFanWandaDemo
//
//  Created by Haoyu Wang on 16/6/27.
//  Copyright © 2016年 fengmap. All rights reserved.
//

#import "CollCellModel.h"

@implementation CollCellModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)collCellModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
