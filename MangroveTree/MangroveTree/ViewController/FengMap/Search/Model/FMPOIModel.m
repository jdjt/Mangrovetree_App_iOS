//
//  FMPOIModel.m
//  mgmanager
//
//  Created by fengmap on 16/7/9.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FMPOIModel.h"

@implementation FMPOIModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)fmPOIModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
