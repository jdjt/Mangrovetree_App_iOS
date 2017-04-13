//
//  NaviTopView.m
//  FeiFanWandaDemo
//
//  Created by Haoyu Wang on 16/7/2.
//  Copyright © 2016年 fengmap. All rights reserved.
//

#import "NaviTopView.h"

@interface NaviTopView ()

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *lengthLab;

@end

@implementation NaviTopView

+ (instancetype)naviTopViewSetFrame:(CGRect)frame {
    NaviTopView *view = [[NSBundle mainBundle] loadNibNamed:@"NaviTopView" owner:self options:nil][0];
    view.frame = frame;
	view.alpha = 0.0f;
    return view;
}

- (void)updateLength:(double)length
{
    self.timeLab.text = @"";
    self.lengthLab.text = @"";
	float time = length/60+0.5;
	if (time<1.0) {
		self.timeLab.text = @"1分钟";
	}
	else
	{
		self.timeLab.text = [NSString stringWithFormat:@" %d 分钟", (int)time];
	}
    self.lengthLab.text = [NSString stringWithFormat:@"全程剩余%.2f米", length];
}

- (IBAction)stopButtonClick:(UIButton *)sender
{
	self.stopNaviBlock();
}

@end
