//
//  FMKNodeAssociation.h
//  FMMapKit
//
//  Created by fengmap on 16/8/29.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMKMap;
@class FMKExternalModel;

@interface FMKNodeAssociation : NSObject

- (instancetype)initWithMap:(FMKMap *)map path:(NSString *)path;

- (void)setMaskByExternalModel:(FMKExternalModel *)externalModel mask:(BOOL)mask;

- (void)setHighlightByExternalModel:(FMKExternalModel *)externalModel highlight:(BOOL)highlight;

@end
