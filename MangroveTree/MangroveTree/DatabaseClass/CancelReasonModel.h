//
//  CancelReasonModel.h
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/4/25.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CancelReasonModel : NSObject

typedef NS_ENUM(NSInteger,CancelReasonType)
{
    ReasonType_NoReceive    = 0,  //   未接单
    ReasonType_Complete     = 1,  //   已完成
};


@property (nonatomic, copy) NSString * causeCode;
@property (nonatomic, copy) NSString * causeDesc;
@property (nonatomic, assign) CancelReasonType reasonType;

@end
