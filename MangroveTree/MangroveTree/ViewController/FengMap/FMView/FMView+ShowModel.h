//
//  FMView+ShowModel.h
//  mgmanager
//
//  Created by fengmap on 16/7/5.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FMView.h"
@class FMKExternalModel;
@interface FMView (ShowModel)

/**
 *  根据FilterType Show模型
 *
 *   type ButtonType
 */
- (void)showExternalModel;

- (void)resetStandardStatus;

- (NSArray *)getPoisByModel:(FMKExternalModel *)model;

@end
