//
//  FMKKalman.h
//  卡尔曼滤波工具类
//  FMMapKit
//
//  Created by fengmap on 16/6/2.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKGeometry.h"

@interface FMKKalman : NSObject

- (instancetype)initWithLenObserve:(int)lenObserve
                          lenState:(int)lenState
                           factorQ:(double)factorQ
                           factorR:(double)factorR;

- (FMKMapPoint)calcuWithOldMapPoint:(FMKMapPoint)oldMapPoint
                withCurrentMapPoint:(FMKMapPoint)currentMapPoint;

@end
