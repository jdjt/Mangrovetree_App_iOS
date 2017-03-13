//
//  FMIndoorMapVC+Navi.h
//  mgmanager
//
//  Created by fengmap on 16/8/23.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FMIndoorMapVC.h"

@interface FMIndoorMapVC (Navi)
- (void)addInforView;
- (void)addNaviPopView;
- (void)addNaviTopView;
- (void)addModelInfoPopView;
- (void)addSwitchMapInfoView;
- (void)setEnableLocationBtnFrameByView:(UIView *)view;

@end
