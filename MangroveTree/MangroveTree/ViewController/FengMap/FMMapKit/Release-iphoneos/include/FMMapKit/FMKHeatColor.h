//
//  FMKHeatColor.h
//  FMMapKit
//
//  Created by fengmap on 15/12/25.
//  Copyright © 2015年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMKHeatColor : NSObject

///热力图颜色
@property (nonatomic,strong) UIColor * color;

///热力图颜色比例因子
@property (nonatomic,assign) float ratio;


@end
