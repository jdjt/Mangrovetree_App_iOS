//
//  FMIndoorMapVC+Navi.m
//  mgmanager
//
//  Created by fengmap on 16/8/23.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FMIndoorMapVC+Navi.h"
#import "SwitchMapInfoView.h"

@implementation FMIndoorMapVC (Navi)

- (void)addInforView
{
    if (!self.inforView)
    {
        self.inforView = [InforView inforView];
        self.inforView.frame = CGRectMake(0, kScreenHeight-kNaviPopViewHeight-49 -85, kScreenWidth, 85);
        [self.view addSubview:self.inforView];
    }
    
    __weak FMIndoorMapVC * wSelf = self;
    
    self.inforView.hideBlock = ^(BOOL hideView)
    {
        [wSelf setNaviPopVIewFrameByShow:hideView];
    };
    
}

//添加导航页面
- (void)addNaviPopView
{
	if (!self.naviPopView) {
		self.naviPopView = [NaviPopView naviPopView];
		self.naviPopView.frame = CGRectMake(0, kScreenHeight-kNaviPopViewHeight-49, kScreenWidth, kNaviPopViewHeight);
		self.naviPopView.alpha = 0.0f;
		[self.view addSubview:self.naviPopView];
		[self addGestureOnView:self.naviPopView];
	}
}
//添加实时导航信息弹框
- (void)addNaviTopView
{
	if (!self.naviTopView) {
		self.naviTopView = [NaviTopView naviTopViewSetFrame:CGRectMake(0, 0, kScreenWidth, kNaviTopViewHeight)];
		self.naviTopView.alpha = 0.0f;
		[self.view addSubview:self.naviTopView];
	}
}

- (void)addModelInfoPopView
{
//	if (!self.modelInfoPopView) {
//		self.modelInfoPopView = [IndoorMapModelInfoPopView indoorMapModelInfoPopView];
//		self.modelInfoPopView.frame = CGRectMake(0, kScreenHeight-kModelInfoPopViewHeight, kScreenWidth, kModelInfoPopViewHeight);
//		[self.view addSubview:self.modelInfoPopView];
//		[self addGestureOnView:self.modelInfoPopView];
//	}
}

- (void)addSwitchMapInfoView
{
	if (!self.switchMapInfoView)
	{
		self.switchMapInfoView = [SwitchMapInfoView switchMapInfoView];
		self.switchMapInfoView.frame = CGRectMake(0, kNaviTopViewHeight, kScreenWidth, kSwitchMapInfoViewHeight);
		[self.view addSubview:self.switchMapInfoView];
	}
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

//根据显示的视图调整定位按钮的位置
- (void)setEnableLocationBtnFrameByView:(UIView *)view
{
	if ([view isKindOfClass:[IndoorMapModelInfoPopView class]]) {
		[UIView animateWithDuration:0.3f animations:^{
//			self.enableLocateBtn.frame = CGRectMake(kLocationSpace, self.modelInfoPopView.frame.origin.y-kLocationSpace-kLocBtnHeight, kLocBtnWidth, kLocBtnHeight);
		}];
	}
	else if ([view isKindOfClass:[NaviPopView class]])
	{
//		[UIView animateWithDuration:0.3f animations:^{
//			self.enableLocateBtn.frame = CGRectMake(kLocationSpace, self.naviPopView.frame.origin.y-kLocationSpace-kLocBtnHeight, kLocBtnWidth, kLocBtnHeight);
//		}];
	}
	else
	{
//		[UIView animateWithDuration:0.3f animations:^{
//			self.enableLocateBtn.frame = CGRectMake(kLocationSpace,kScreenHeight-kLocationSpace-kLocBtnHeight, kLocBtnWidth, kLocBtnHeight);
//		}];
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


@end
