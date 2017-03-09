//
//  RouteDisplayView.h
//  mgmanager
//
//  Created by fengmap on 16/8/14.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnRouteNaviResult)(NSArray * routeNaviResult, NSArray * points);
typedef void(^RouteSelectedBtnClick)();
typedef void(^SelectedPointIndex)(int index);

@interface RouteDisplayView : UIView

@property (strong, nonatomic) IBOutlet UIButton *topLeftBtn;
@property (strong, nonatomic) IBOutlet UIButton *topRightBtn;
@property (strong, nonatomic) IBOutlet UIButton *bottomLeftBtn;
@property (strong, nonatomic) IBOutlet UIButton *bottomRightBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewWidth;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *businessBtn1;
@property (strong, nonatomic) IBOutlet UIButton *foodBtn1;
@property (strong, nonatomic) IBOutlet UIButton *relaxBtn1;
@property (strong, nonatomic) IBOutlet UIButton *businessBtn2;
@property (strong, nonatomic) IBOutlet UIButton *foodBtn2;
@property (strong, nonatomic) IBOutlet UIButton *relaxBtn2;

@property (nonatomic, copy) ReturnRouteNaviResult returnRouteNaviResult;
@property (nonatomic, copy) RouteSelectedBtnClick routeSelectedBlock;
@property (nonatomic, copy) SelectedPointIndex selectedPointIndex;

+ (instancetype)routeDisplayView;

- (void)addNumberLineViewByActivityNames:(NSArray *)names;

@end
