//
//  FMBaseView.h
//  mgmanager
//
//  Created by fengmap on 16/8/10.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMapKit.h"

@interface FMBaseView : UIView


@property (nonatomic, strong) FMKNaviContraint * naviContraint;

- (void)addFengMapView;


@end
