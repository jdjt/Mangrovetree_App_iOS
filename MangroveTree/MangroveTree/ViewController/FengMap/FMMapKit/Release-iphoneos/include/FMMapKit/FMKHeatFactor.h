//
//  FMKHeatFactor.h
//  FMMapKit
//
//  Created by fengmap on 15/12/25.
//  Copyright © 2015年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMKGeometry.h"

@interface FMKHeatFactor : NSObject

///热力图排布点
@property(nonatomic,assign) FMKMapPoint mapPoint;

///排布点的权重值
@property (nonatomic,assign)float weight;


@end
