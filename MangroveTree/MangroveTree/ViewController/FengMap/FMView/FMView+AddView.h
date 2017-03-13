//
//  FMView+AddView.h
//  mgmanager
//
//  Created by fengmap on 16/9/1.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FMView.h"

@class MapViewController;

@interface FMView (AddView)
//- (void)addModelInfoPopView;
- (void)addInforView;
- (void)addNaviTopView;
- (void)addNaviPopView;
- (void)addCategoryView;
- (void)addSwitchMapInfoView;
- (void)setEnableLocationBtnFrameByView:(UIView *)view;
- (void)showProgressWithText:(NSString *)text;
- (MapViewController *)getCurrentController;

@end
