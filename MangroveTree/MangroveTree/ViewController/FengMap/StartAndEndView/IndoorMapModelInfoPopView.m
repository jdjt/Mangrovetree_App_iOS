//
//  IndoorMapModelInfoPopVIew.m
//  mgmanager
//
//  Created by fengmap on 16/8/23.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "IndoorMapModelInfoPopView.h"
#import "UILabel+AddtionString.h"
#import "QueryDBModel.h"

@implementation IndoorMapModelInfoPopView

- (IBAction)goHereBtnClick:(id)sender {
	self.goHereBlock();
}

- (IBAction)detailBtnClick:(id)sender {
}

+ (instancetype)indoorMapModelInfoPopView
{
	IndoorMapModelInfoPopView * view = [[NSBundle mainBundle] loadNibNamed:@"IndoorMapModelInfoPopView" owner:nil options:nil][0];
	view.alpha = 0.0f;
	return view;
}

- (void)setupModelName:(NSString *)modelName
{
	if (!modelName) {
		self.modelNameLabel.text = @"暂无名称";
	}
	else
	{
		self.modelNameLabel.text = modelName;
	}
}
- (void)show
{
    
}
- (void)hide
{
    
}
- (void)setupModelInfoByNodel:(QueryDBModel *)model
{
	CGFloat nameWidth;
	if (!model.name) {
		nameWidth = [UILabel getWidthByContent:@"暂无名称" font:[UIFont systemFontOfSize:16.0]];
		self.modelNameLabel.text = @"暂无名称";
	}
	else
	{
		nameWidth = [UILabel getWidthByContent:model.name font:[UIFont systemFontOfSize:16.0]];
		self.modelNameLabel.text = model.name;
	}
	
	CGRect rect = self.modelNameLabel.frame;
	self.modelNameLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, nameWidth+5, rect.size.height);
	
	
	if (!model.address) {
		self.modelNameLabel.center = self.topBackView.center;
		self.modelPositionLabel.text = nil;
	}
	else
	{
		self.modelNameLabel.frame = CGRectMake(5, self.topBackView.frame.size.height/2-rect.size.height/2.0, nameWidth, rect.size.height);
		self.modelPositionLabel.text = [NSString stringWithFormat:@"%@ · %@",model.typeName,model.address];
		CGRect positionRect = self.modelPositionLabel.frame;
		self.modelPositionLabel.frame = CGRectMake(self.modelNameLabel.frame.origin.x+nameWidth+5, positionRect.origin.y, positionRect.size.width, positionRect.size.height);
	}
}

- (void)goHereBlock:(GoHereBlock)goHereBlock
{
	self.goHereBlock();
}
@end
