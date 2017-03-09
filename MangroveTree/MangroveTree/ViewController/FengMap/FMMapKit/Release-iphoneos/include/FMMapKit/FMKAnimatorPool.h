//
//  FMKAnimatorPool.h
//  FMMapKit
//
//  Created by fengmap on 16/3/14.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMKAnimator;

@interface FMKAnimatorPool : NSObject

+ (instancetype)shareFMKAnimatorPool;

- (void)addAnimator:(FMKAnimator *)animator;

- (void)cancel;

@end
