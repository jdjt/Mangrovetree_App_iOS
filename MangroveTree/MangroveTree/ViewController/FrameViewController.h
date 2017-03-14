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

@interface FrameViewController : UIViewController

@property (weak, nonatomic) MapViewController *mapVC;

@property (weak, nonatomic) IBOutlet UIButton *hotelNameButton;
@property (assign, nonatomic) NSInteger lastSelectedIndex;
@property (strong, nonatomic) DBCallTask *currentTask;

- (void)addLocationOnMap:(DBCallTask *)task;

- (void)removeLocationOnMap:(DBCallTask *)task;

- (void)testDistanceBy:(DBCallTask *)task;

- (void)changNavViewStyleByLayerMode:(NaviBarType)type;

- (void)startMessageViewLoadBy:(DBCallTask *)task;

- (void)showCallView:(BOOL)show;

- (void)showCallResult:(BOOL)show;

- (void)showMsgView:(BOOL)show;

- (NSString *)getCurrentZoneName;

@end
