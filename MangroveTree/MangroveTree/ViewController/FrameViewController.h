//
//  CenterViewController.h
//  mgmanager
//
//  Created by chao liu on 16/11/24.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

/**
 * @abstract 导航栏样式
 */
typedef NS_ENUM(NSInteger,NaviBarType)
{
    NAVIVARTYPE_MAP           = 0,
    NAVIVARTYPE_CALL          = 1,
    NAVIVARTYPE_IN            = 2,
    NAVIVARTYPE_OUT           = 3,
};
typedef NS_ENUM(NSInteger, CurrentFunction)
{
    FUNCTION_MAP        = 1,
    FUNCTION_DEFAULT    = 2,
};
/**
 * @abstract 底部栏选择
 */
typedef NS_ENUM(NSInteger,SegmentSelected)
{
    Segment_none                = -2,
    Segment_default             = -1,
    Segment_toWhere             = 0,
    Segment_toWorld             = 1,
    Segment_toService           = 2,
};

@interface FrameViewController : UIViewController

@property (weak, nonatomic) MapViewController *mapVC;

@property (strong, nonatomic) DBCallTask *currentTask;
@property (assign, nonatomic) CurrentFunction function;

- (void)addLocationOnMap:(DBCallTask *)task;

- (void)removeLocationOnMap:(DBCallTask *)task;

- (void)changNavViewStyleByLayerMode:(NaviBarType)type;

- (void)showBottomView:(SegmentSelected)select;

- (NSString *)getCurrentZoneName;

@end
