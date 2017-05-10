//
//  FMView.h
//  mgmanager
//
//  Created by fengmap on 16/6/29.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//
#import "FMBaseView.h"
#import "QueryDBModel.h"
#import "InforView.h"

@class CategoryView,ModelInfoPopView;

@class FMKMapView,FMMangroveMapView;
@class  MapViewController;
@class  FMMapKit;
@class  ChooseFloorScrollView;
@class  ModelInfoPopView, NaviPopView,NaviTopView,RouteDisplayView,SwitchMapInfoView,NavigationBarView;
typedef NS_ENUM(NSInteger,ButtonType)
{
	ButtonType_SERVICE        = 1,
	ButtonType_SHOP           = 2,
	ButtonType_FOOD           = 3,
	ButtonType_ROUTE_FOOD1    = 4,
	ButtonType_ROUTE_RELAX1   = 5,
	ButtonType_ROUTETHREE      = 6,
	ButtonType_ROUTEFOUR       = 7,
	ButtonType_ROUTEFIVE       = 8,
	ButtonType_ROUTESIX        = 9,
	ButtonType_ROUTEBUTTON     = 10,
	ButtonType_NOTFOUND
};



@interface FMView : FMBaseView<FMKLocationServiceManagerDelegate>
///地图视图
@property (nonatomic, strong) FMMangroveMapView * fengMapView;
//@property (nonatomic, strong) ModelInfoPopView * modelInfoPopView;
@property (nonatomic, strong) RouteDisplayView * routeDisplayView;
@property (nonatomic, strong) CategoryView * categoryView;
@property (nonatomic, strong) NaviPopView * naviPopView;
@property (nonatomic, strong) NaviTopView * naviTopView;
@property (nonatomic, strong) SwitchMapInfoView * switchMapInfoView;//倒计时
@property (nonatomic, strong) InforView *inforView;
@property (nonatomic, strong) NavigationBarView * navigationBarView;
@property (nonatomic, strong) UIButton * enableLocateBtn;
@property (nonatomic, assign) BOOL showChangMap;
@property (nonatomic, assign) BOOL isFirstLocate;//判断在导航时是否是第一次定位
//@property (nonatomic, assign) BOOL inDoorMap;
//@property (nonatomic, weak) MapViewController *mapVC;
@property (nonatomic, assign) BOOL mapFinish;
///d地图数据路径
@property (nonatomic,copy) NSString * mapPath;
///按钮类型
@property (nonatomic,assign) ButtonType type;
///Show列表
@property (nonatomic, strong) NSMutableArray * showList;

@property (nonatomic, strong) FMKLocationService * locationService;

///添加地图视图
- (void)addFengMapView;
//重设主题
- (void)resetTheme;
- (void)getMacAndStartLocationService;
- (void)addlocateBtn;
- (void)hideRouteDisplayView;
- (void)showRouteDisplayView;

- (void)stopNavi;
- (void)addLocationDelegate;

- (void)planNaviAct;

//地图进入导航模式
- (void)mapEnterNaviMode;
- (void)hideNaviBar:(BOOL)hide;
- (void)hideNavView;

@end
