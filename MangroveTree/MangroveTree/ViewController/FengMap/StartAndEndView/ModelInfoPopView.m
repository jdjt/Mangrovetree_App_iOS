//
//  ModelInfoPopView.m
//  mgmanager
//
//  Created by fengmap on 16/8/11.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "ModelInfoPopView.h"
#import "FMKExternalModel.h"
#import "ParserJsondata.h"
#import "IndoorMapInfo.h"
#import "QueryDBModel.h"
#import "DBSearchTool.h"
#import "UILabel+AddtionString.h"

@interface ModelInfoPopView()
{
	NSArray * _indoorMapInfos;
	NSString * _modelFid;
	NSString * _indoorMapID;
	FMKExternalModel * _model;
}
@end

@implementation ModelInfoPopView

+ (instancetype)modelInfoPopView
{
	ModelInfoPopView * view = [[NSBundle mainBundle] loadNibNamed:@"ModelInfoPopView" owner:nil options:nil][0];
	view.alpha = 0.0f;
	view.modelName.adjustsFontSizeToFitWidth = YES;
	view.modelPositionLabel.adjustsFontSizeToFitWidth = YES;
	return view;
}

- (IBAction)goHereBtnClick:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(goHere:)]) {
		[self.delegate goHere:_model.mapCoord];
	}
}
- (IBAction)detailBtnClick:(id)sender
{
	
}

- (IBAction)enterIndoorBtnClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterIndoorMapBtnClick:)])
    {
        [self.delegate enterIndoorMapBtnClick:_indoorMapID];
    }
}

- (void)setupInfoByModel:(FMKExternalModel *)model
{
	BOOL enableEnterIndoor = NO;
	_model = model;
//	if ([model.name isEqualToString:@""]) {
//		self.modelName.text = @"暂无名称";
//	}
//	else
//	{
//		self.modelName.text = model.name;
//	}
	
	
	if (!_indoorMapInfos) {
		_indoorMapInfos = [ParserJsondata  parserIndoorMap];
	}
	_modelFid = model.fid;
	//找到对应的室内地图ID
	for (IndoorMapInfo * info in _indoorMapInfos) {
		if ([model.fid isEqualToString:info.model_fid]) {
			enableEnterIndoor = YES;
			_indoorMapID = info.map_mid;
		}
	}
	
	//判断是否能够进入室内
	if (!enableEnterIndoor) {
		[self.enterIndoorBtn setImage:[UIImage imageNamed:@"noEnter"] forState:UIControlStateNormal];
		self.enterIndoorBtn.enabled = NO;
	}
	else
	{
		[self.enterIndoorBtn setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
		self.enterIndoorBtn.enabled = YES;
	}
	
	//设置能否进入室内的布局
	[self setupBottomView:enableEnterIndoor];
	
	QueryDBModel * dbModel = [[DBSearchTool shareDBSearchTool] queryModelByFid:model.fid];
	//设置模型信息弹框
	[self setupModelInfoByNodel:dbModel externalModel:model];
	
}
- (void)setupModelInfoByNodel:(QueryDBModel *)model externalModel:(FMKExternalModel *)eModel;
{
	CGFloat nameWidth;
	if ([eModel.name isEqualToString:@""]) {
		nameWidth = [UILabel getWidthByContent:@"暂无名称" font:[UIFont systemFontOfSize:16.0]];
		self.modelName.text = @"暂无名称";
	}
	else
	{
		nameWidth = [UILabel getWidthByContent:eModel.name font:[UIFont systemFontOfSize:16.0]];
		self.modelName.text = eModel.name;
	}
	
	CGRect rect = self.modelName.frame;
	self.modelName.frame = CGRectMake(rect.origin.x, rect.origin.y, nameWidth+5, rect.size.height);
	
	
	if (!model.address) {
		self.modelPositionLabel.text = @"";
		self.modelName.center = self.topBackgroudView.center;
	}
	else
	{
		self.modelName.frame = CGRectMake(5, self.topBackgroudView.frame.size.height/2-rect.size.height/2.0, nameWidth, rect.size.height);
		self.modelPositionLabel.text = [NSString stringWithFormat:@"%@ · %@",model.typeName,model.address];
		CGRect positionRect = self.modelPositionLabel.frame;
		self.modelPositionLabel.frame = CGRectMake(self.modelName.frame.origin.x+nameWidth+5, positionRect.origin.y, positionRect.size.width, positionRect.size.height);
	}
}

- (void)setupBottomView:(BOOL)enableEnterIndoor
{
	if (!enableEnterIndoor) {
		self.separateView.hidden = YES;
		self.enterIndoorBtn.hidden = YES;

		CGPoint center;
		center.x = self.backGroudView.frame.size.width/2;
		center.y = self.backGroudView.frame.size.height/2;
		self.goHereBtn.center = center;
	}
	else
	{
		self.separateView.hidden = NO;
		self.enterIndoorBtn.hidden = NO;
		CGSize size = self.goHereBtn.frame.size;
		self.goHereBtn.frame = CGRectMake(8, 13.5, size.width, size.height);
		[self.backGroudView updateConstraints];
	}
}

- (void)dealloc
{
	NSLog(@"modelinfopopview dealloc");
}

@end
