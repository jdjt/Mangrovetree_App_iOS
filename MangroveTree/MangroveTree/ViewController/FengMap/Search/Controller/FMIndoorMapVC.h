//
//  FMIndoorMapVC.h
//  mgmanager
//
//  Created by fengmap on 16/7/8.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IndoorMapModelInfoPopView.h"
#import "NaviPopView.h"
#import "NaviTopView.h"
#import "InforView.h"

@class SwitchMapInfoView;

#import "Const.h"

@class QueryDBModel;

@interface FMIndoorMapVC : UIViewController

@property (nonatomic, copy) NSString *mapID;//地图ID
@property (nonatomic, copy) NSString * displayGroupID;//显示的楼层ID
@property (nonatomic, copy) NSString * mapName;

@property (nonatomic, strong) QueryDBModel * dbModel;//数据库模型，数据

//信息弹框
//@property (nonatomic, strong) IndoorMapModelInfoPopView * modelInfoPopView;
@property (nonatomic, strong) InforView *inforView;
@property (nonatomic, strong) NaviPopView * naviPopView;
@property (nonatomic, strong) NaviTopView * naviTopView;
@property (nonatomic, strong) SwitchMapInfoView * switchMapInfoView;
@property (nonatomic, strong) UIButton * enableLocateBtn;

@property (nonatomic, assign) BOOL isNeedLocate;//判断是否需要定位

- (instancetype)initWithMapID:(NSString *)mapID ;

- (void)stopNavi;
- (void)setupNaviPopView;
@end
