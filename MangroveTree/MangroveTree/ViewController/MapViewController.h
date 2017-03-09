//
//  MapViewController.h
//  mgmanager
//
//  Created by chao liu on 16/11/24.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryDBModel.h"

@class FrameViewController;
@class FMView;

@interface MapViewController : UIViewController

@property (nonatomic, weak) FrameViewController *centerVC;
@property (nonatomic,strong) FMView * fmView;
@property (nonatomic, strong) QueryDBModel * dbModel;//数据库模型，数据

// 加载地图
- (void)loadMap;

@end
