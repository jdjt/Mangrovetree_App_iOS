//
//  MapInfos.h
//  StaticModelDemo
//
//  Created by fengmap on 16/5/19.
//  Copyright © 2016年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MapInfos : NSObject

@property (nonatomic,copy)NSString * ErrorText;
@property (nonatomic,strong)NSNumber * ErrorCode;
@property (nonatomic,strong)NSMutableArray * MapDetail;
@property (nonatomic,assign)BOOL Success;

@end
