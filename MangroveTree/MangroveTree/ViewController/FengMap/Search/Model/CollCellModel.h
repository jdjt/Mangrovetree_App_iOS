//
//  CollCellModel.h
//  FeiFanWandaDemo
//
//  Created by Haoyu Wang on 16/6/27.
//  Copyright © 2016年 fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollCellModel : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *text;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)collCellModelWithDict:(NSDictionary *)dict;

@end
