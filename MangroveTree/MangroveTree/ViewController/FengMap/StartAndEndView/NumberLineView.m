//
//  PointView.m
//  mgmanager
//
//  Created by fengmap on 16/8/14.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "NumberLineView.h"



@interface NumberLineView()


@end

@implementation NumberLineView

+ (instancetype)numberLineView
{
	NumberLineView * view = [[NSBundle mainBundle] loadNibNamed:@"NumberLineView" owner:nil options:nil][0];

	view.numLabel.layer.cornerRadius = view.numLabel.frame.size.width/2.0;
	view.numLabel.layer.masksToBounds = YES;
	
	view.numLabel.backgroundColor = SETCOLOR(79, 72, 75);
	view.numPointBtn.backgroundColor = [UIColor whiteColor];
	view.numLabel.textColor = [UIColor whiteColor];
	[view.numPointBtn setTitleColor:SETCOLOR(81, 81, 81) forState:UIControlStateNormal];
	view.numPointBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
	
	return view;
}


- (IBAction)numPointBtnClick:(id)sender
{
	UIButton * btn = (UIButton *)sender;
	btn.selected = !btn.selected;
	
	if (btn.selected)
	{
		btn.backgroundColor = SETCOLOR(65, 125, 86);
		[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		
		self.numLabel.backgroundColor = SETCOLOR(65, 125, 86);
		self.numLabel.textColor = [UIColor whiteColor];
	}
	else
	{
		btn.backgroundColor = [UIColor whiteColor];
		[btn setTitleColor:SETCOLOR(81, 81, 81) forState:UIControlStateNormal];
		self.numLabel.backgroundColor = SETCOLOR(79, 72, 75);
	}
	if ([self.delegate respondsToSelector:@selector(numberLineBtnClick:)]) {
		[self.delegate numberLineBtnClick:self];
	}
	
	self.buttonClick(btn,self.numLabel);
}

- (void)updateConstraints
{
	[super updateConstraints];
	[self.numPointBtn sizeToFit];
}

@end
