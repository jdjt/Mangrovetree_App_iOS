//
//  FMKInterpolator.h
//  FMMapKit
//
//  Created by FengMap on 15/11/4.
//  Copyright © 2015年 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKGeometry.h"


typedef double DurationTime;
typedef double GoingTime;
typedef double OriginalValue;
typedef double ChangedValue;

typedef NS_ENUM(NSInteger)
{
    STAGE_IN = 0,
    STAGE_OUT,
    STAGE_INOUT
    
}STAGE_TYPE;

@interface FMKInterpolator : NSObject

/**
 *  缓动函数插值类型
 */
@property(nonatomic,assign) STAGE_TYPE type;

/**
 *  插值器初始化
 *
 *  @param STAGE_TYPE 插值类型 默认使用USE_INOUT
 *
 *  @return 插值器对象
 */
-(instancetype)initWith:(STAGE_TYPE)STAGE_TYPE;



- (double)inWithGoingTime:(GoingTime)goingTime
                 withStart:(OriginalValue )start
                  withEnd:(ChangedValue )changed
         withDurationTime:(DurationTime)durationTime;

- (double)outWithGoingTime:(GoingTime)goingTime
                 withStart:(OriginalValue )start
                   withEnd:(ChangedValue )changed
          withDurationTime:(DurationTime)durationTime;


- (double)inOutWithGoingTime:(GoingTime)goingTime
                   withStart:(OriginalValue)start
                     withEnd:(ChangedValue )changed
            withDurationTime:(DurationTime)durationTime;


@end
