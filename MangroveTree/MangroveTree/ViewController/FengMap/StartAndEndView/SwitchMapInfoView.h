//
//  SwitchMapInfoView.h
//  mgmanager
//
//  Created by fengmap on 16/12/17.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchMapInfoBtnDelegate <NSObject>

- (void)switchMapInfoBtnClick;

@end


/**
 导航状态下切换地图控件
 */
@interface SwitchMapInfoView : UIView
@property (nonatomic, weak) id<SwitchMapInfoBtnDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *switchMapBtn;
@property (strong, nonatomic) IBOutlet UILabel *switchMapInfoLabel;

+ (instancetype)switchMapInfoView;
- (IBAction)switchMapBtnClick:(id)sender;

- (void)show;
- (void)hide;

@end
