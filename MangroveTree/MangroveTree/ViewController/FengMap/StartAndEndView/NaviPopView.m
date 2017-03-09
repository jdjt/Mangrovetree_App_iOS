//
//  NaviPopView.m
//  mgmanager
//
//  Created by fengmap on 16/8/11.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "NaviPopView.h"
#import "Const.h"
#import "FMKLocationService.h"
#import "FMKGeometry.h"
@interface NaviPopView()
{
	
}
@end

@implementation NaviPopView

+ (instancetype)naviPopView
{
	 NaviPopView * view = [[NSBundle mainBundle] loadNibNamed:@"NaviPopView" owner:nil  options:nil][0];
	view.alpha = 0.0f;
	return view;
}

- (void)hide
{
	__weak typeof(self)wSelf = self;
	[UIView animateWithDuration:0.4f animations:^{
		wSelf.alpha = 0.0f;
	}];
}

- (void)show
{
	self.alpha = 1.0f;
	__weak typeof(self)wSelf = self;
	[UIView animateWithDuration:0.4f animations:^{
		CGRect rect = self.frame;
		wSelf.frame = CGRectMake(0, kScreenHeight-rect.size.height, kScreenWidth, rect.size.height);
	}];
}
- (IBAction)switchStartAndEndBtnClick:(id)sender {
	if ([self.delegate respondsToSelector:@selector(switchStartAndEnd)]) {
		[self.delegate switchStartAndEnd];
	}
	
	[self.startPointBtn setTitle:self.endPointBtn.titleLabel.text forState:UIControlStateNormal];
	[self.endPointBtn setTitle:@"我的位置" forState:UIControlStateNormal];
	self.switchStartAndEndBlock();
	
}
- (IBAction)startNaviBtnClick:(id)sender {
	self.startNaviBlock();
}

- (void)setTimeByLength:(double)length
{
	float time = (float)length/60+0.5;
	if (time<1.0) {
		self.timeLabel.text = @"1分钟";
	}
	else
	{
		self.timeLabel.text = [NSString stringWithFormat:@"%d分钟",(int)time];
	}
	
	self.lengthLabel.text = [NSString stringWithFormat:@"%.2f米",(float)length];
	
	float calorie = (float) (time * kHourCalorie + 0.5);
	[self.powerLabel setTitle:[NSString stringWithFormat:@"消耗%d卡路里",(int)calorie] forState:UIControlStateNormal];
}

- (void)swipeGestureAct:(UISwipeGestureRecognizer *)gesture
{
	__weak typeof(self)wSelf = self;
	[UIView animateWithDuration:0.4f animations:^{
		CGRect rect = self.frame;
		wSelf.frame = CGRectMake(0, kScreenHeight, rect.size.width, rect.size.height);
	} completion:^(BOOL finished) {
		wSelf.alpha = 0.0f;
	}];
    if ([self.delegate respondsToSelector:@selector(switchStartAndEnd)]) {
        [self.delegate switchStartAndEnd];
    }

}


- (void)dealloc
{
	NSLog(@"navipopview dealloc");
}

@end
