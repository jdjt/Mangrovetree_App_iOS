//
//  FMKLabel.h
//  FMMapKit
//
//  Created by fengmap on 16/3/7.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import "FMKNode.h"

@interface FMKLabel : FMKNode

//标签文本内容
@property (nonatomic, readonly) NSString *name;

@property (nonatomic, assign) BOOL maskMode;

@property (nonatomic, assign) BOOL highlight;

@end
