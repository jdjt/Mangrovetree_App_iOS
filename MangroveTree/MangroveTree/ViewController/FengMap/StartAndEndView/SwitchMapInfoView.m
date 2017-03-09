//
//  SwitchMapInfoView.m
//  mgmanager
//
//  Created by fengmap on 16/12/17.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "SwitchMapInfoView.h"

const int kCountDown = 10;

@interface SwitchMapInfoView()
{
	NSTimer * _timer;//倒计时计时器
	int _currentCountDown;//当前计时器示数
}
@end

@implementation SwitchMapInfoView

+ (instancetype)switchMapInfoView
{
	SwitchMapInfoView * view = [[NSBundle mainBundle] loadNibNamed:@"SwitchMapInfoView" owner:nil options:nil][0];
	[view.switchMapBtn.layer setMasksToBounds:YES];
	[view.switchMapBtn.layer setCornerRadius:view.switchMapBtn.frame.size.height/2.0]; //设置矩形四个圆角半径
	[view.switchMapBtn.layer setBorderWidth:1.0]; //边框宽度
//	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//	CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
//		[view.switchMapBtn.layer setBorderColor:colorref];//边框颜色
	view.hidden = YES;
	return view;
}

- (IBAction)switchMapBtnClick:(id)sender
{
	[self hide];
	[self btnClick];
}

- (void)show
{
	self.hidden = NO;
	_currentCountDown = kCountDown;
	[_timer invalidate];
	_timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)hide
{
	self.hidden = YES;
	[_timer invalidate];
    _timer = nil;
	_currentCountDown = kCountDown;
}

//计时器触发的方法
- (void)countDown
{
	//倒计时达到条件
	if (--_currentCountDown != 0)
	{
		NSString * btnInfo = [NSString stringWithFormat:@"立即切换(%ds)",_currentCountDown];
		[self.switchMapBtn setTitle:btnInfo forState:UIControlStateNormal];
		[self.switchMapBtn setTintAdjustmentMode:UIViewTintAdjustmentModeAutomatic];
	}
	else
	{
		[self btnClick];
		[self hide];
	}
}

- (void)btnClick
{
	if ([self.delegate respondsToSelector:@selector(switchMapInfoBtnClick)])
	{
		[self.delegate switchMapInfoBtnClick];
	}
}

- (void)dealloc
{
	NSLog(@"switchMapInfoView dealloc");
}

@end
