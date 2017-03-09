//
//  FMKLocationBorder.h
//  FMMapKit
//
//  Created by fengmap on 16/12/23.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMKLocationBorder : NSObject

@property (nonatomic, copy) NSString * border_code;
@property (nonatomic, copy) NSString * border_name;
@property (nonatomic, strong) NSArray * border_coords;

@end
