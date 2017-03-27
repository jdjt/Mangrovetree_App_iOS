//
//  FMView+AddView.m
//  mgmanager
//
//  Created by fengmap on 16/9/1.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FMView+AddView.h"
#import "ModelInfoPopView.h"
#import "NaviPopView.h"
#import "NaviTopView.h"
#import "RouteDisplayView.h"
#import "Const.h"
#import "MapViewController.h"
#import "MBProgressHUD.h"
#import "CategoryView.h"
#import "SwitchMapInfoView.h"

const int kCategoryViewWidth = 50;
const int kLeftSpace = 10;
const int kCategoryViewHeight = 290;
const int kTopSpace = 10;

@implementation FMView (AddView)

//- (void)addModelInfoPopView
//{
//	if (!self.modelInfoPopView) {
//		self.modelInfoPopView = [ModelInfoPopView modelInfoPopView];
//		self.modelInfoPopView.frame = CGRectMake(0,self.frame.size.height- kModelInfoPopViewHeight, self.frame.size.width, kModelInfoPopViewHeight);
//		[self addGestureOnView:self.modelInfoPopView];
//		[self addSubview:self.modelInfoPopView];
//	}
//}
- (void)addInforView
{
    if (!self.inforView)
    {
        self.inforView = [InforView inforView];
        self.inforView.frame = CGRectMake(0, kScreenHeight-kNaviPopViewHeight-49 -85, kScreenWidth, 85);
        [self addSubview:self.inforView];
    }
    __weak FMView * wSelf = self;

    self.inforView.hideBlock = ^(BOOL hideView)
    {
        [wSelf setNaviPopVIewFrameByShow:hideView];
    };
}
- (void)addCategoryView
{
	if (!self.categoryView) {
		CGSize size = self.frame.size;
		self.categoryView = [CategoryView categoryView];
		self.categoryView.frame = CGRectMake(size.width-kLeftSpace-kCategoryViewWidth, kTopSpace+kNaviHeight, kCategoryViewWidth, kCategoryViewHeight);
		[self addSubview:self.categoryView];
	}
}

//添加导航页面
- (void)addNaviPopView
{
	if (!self.naviPopView) {
		self.naviPopView = [NaviPopView naviPopView];
		self.naviPopView.frame = CGRectMake(0, kScreenHeight-kNaviPopViewHeight-49, kScreenWidth, kNaviPopViewHeight);
		self.naviPopView.alpha = 0.0f;
		[self addGestureOnView:self.naviPopView];//添加手势事件
		[self addSubview:self.naviPopView];
	}
}
//添加实时导航信息弹框
- (void)addNaviTopView
{
	if (!self.naviTopView) {
		self.naviTopView = [NaviTopView naviTopViewSetFrame:CGRectMake(0, 0, kScreenWidth, kNaviTopViewHeight)];
		self.naviTopView.alpha = 0.0f;
		[self addSubview:self.naviTopView];
	}
}

- (void)addSwitchMapInfoView
{
	if (!self.switchMapInfoView)
	{
		self.switchMapInfoView = [SwitchMapInfoView switchMapInfoView];
		self.switchMapInfoView.frame = CGRectMake(0, kNaviTopViewHeight, kScreenWidth, kSwitchMapInfoViewHeight);
		[self addSubview:self.switchMapInfoView];
	}
}

//根据显示的视图调整定位按钮的位置
- (void)setEnableLocationBtnFrameByView:(UIView *)view
{
	if ([view isKindOfClass:[ModelInfoPopView class]]) {
		[UIView animateWithDuration:0.3f animations:^{
//			self.enableLocateBtn.frame = CGRectMake(kLocationSpace, self.modelInfoPopView.frame.origin.y-kLocationSpace-kLocBtnHeight, kLocBtnWidth, kLocBtnHeight);
		}];
	}
	else if ([view isKindOfClass:[NaviPopView class]])
	{
		[UIView animateWithDuration:0.3f animations:^{
			self.enableLocateBtn.frame = CGRectMake(kLocationSpace, self.naviPopView.frame.origin.y-kLocationSpace-kLocBtnHeight, kLocBtnWidth, kLocBtnHeight);
		}];
	}
	else if([view isKindOfClass:[RouteDisplayView class]])
	{
		[UIView animateWithDuration:0.3f animations:^{
			self.enableLocateBtn.frame = CGRectMake(kLocationSpace,kScreenHeight-kLocationSpace-kLocBtnHeight-kRouteViewHeight, kLocBtnWidth, kLocBtnHeight);
		}];
	}
	else
	{
		[UIView animateWithDuration:0.3f animations:^{
			self.enableLocateBtn.frame = CGRectMake(kLocationSpace,kScreenHeight-kLocationSpace-kLocBtnHeight, kLocBtnWidth, kLocBtnHeight);
		}];
	}
}
- (void)setNaviPopVIewFrameByShow:(BOOL)show
{
    self.naviPopView.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.inforView.frame = CGRectMake(0, show == YES ? kScreenHeight-49 -85:kScreenHeight -49 - 85 -self.naviPopView.frame.size.height, self.inforView.frame.size.width, self.inforView.frame.size.height);
        self.naviPopView.frame = CGRectMake(0, show == YES ? kScreenHeight - 49 : kScreenHeight-self.naviPopView.frame.size.height-49, self.naviPopView.frame.size.width, self.naviPopView.frame.size.height);
    } completion:^(BOOL finished)
    {
        self.naviPopView.hidden = show;
        [self.naviPopView setupBottomView];
    }];
    
}
//添加手势
- (void)addGestureOnView:(UIView *)view
{
	UISwipeGestureRecognizer * gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAct:)];
	gesture.direction = UISwipeGestureRecognizerDirectionDown;
	[view addGestureRecognizer:gesture];
}

- (void)swipeGestureAct:(UISwipeGestureRecognizer *)gesture
{
	[UIView animateWithDuration:0.4f animations:^{
		gesture.view.alpha = 0.0f;
	}];
	[self setEnableLocationBtnFrameByView:nil];
    [self stopNavi];
}

- (void)showProgressWithText:(NSString *)text
{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
	hud.alpha = 0.6;
	hud.mode = MBProgressHUDModeText;
	hud.labelText = text;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1.0f];
}
- (MapViewController *)getCurrentController
{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[MapViewController class]]) {
            return (MapViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
@end
