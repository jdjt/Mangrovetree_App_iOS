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
#import "FMKExternalModel.h"
#import "ParserJsondata.h"
#import "IndoorMapInfo.h"
#import "QueryDBModel.h"
#import "DBSearchTool.h"
#import "UILabel+AddtionString.h"
#import "UIViewExt.h"

@interface NaviPopView()
{
    NSArray * _indoorMapInfos;
    NSString * _modelFid;
    NSString * _indoorMapID;
    FMKExternalModel * _model;
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
	self.alpha = 0.9f;
	__weak typeof(self)wSelf = self;
	[UIView animateWithDuration:0.4f animations:^{
		CGRect rect = self.frame;
		wSelf.frame = CGRectMake(0, kScreenHeight-rect.size.height-49, kScreenWidth, rect.size.height);
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
- (IBAction)startNaviBtnClick:(id)sender
{
    if (_startNaviBlock)
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
//        [self.enterIndoorBtn setImage:[UIImage imageNamed:@"noEnter"] forState:UIControlStateNormal];
        self.enterIndoorBtn.enabled = NO;
    }
    else
    {
//        [self.enterIndoorBtn setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
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
    NSString *name = @"暂无名称";

    if ([eModel.name isEqualToString:@""])
    {
       name = @"暂无名称";
    }
    else
    {
        
        name = eModel.name;
    }
    
    
    
    
    
    if (!model.address) {
//        self.modelPositionLabel.text = @"";
    
    }
    else
    {
        
//        self.modelPositionLabel.text = [NSString stringWithFormat:@"%@ · %@",model.typeName,model.address];
//        CGRect positionRect = self.modelPositionLabel.frame;
//        self.modelPositionLabel.frame = CGRectMake(self.modelName.frame.origin.x+nameWidth+5, positionRect.origin.y, positionRect.size.width, positionRect.size.height);
    }
    [self.endPointBtn setTitle:name forState:UIControlStateNormal];

}
- (void)setupModelInfoByNodel:(QueryDBModel *)model
{
    [self setupBottomView:NO];
}

- (void)setupBottomView:(BOOL)enableEnterIndoor
{
    self.enterIndoorBtn.hidden = !enableEnterIndoor;
    self.startNavBtn.frame = CGRectMake(kScreenWidth - self.startNavBtn.width -8, 6,  self.startNavBtn.width, enableEnterIndoor == YES ? 34 : 88 - 6*2);
    self.enterIndoorBtn.frame = CGRectMake(kScreenWidth - self.enterIndoorBtn.width -8, self.startNavBtn.bottom +6, self.enterIndoorBtn.width, self.enterIndoorBtn.height);
}

- (void)dealloc
{
	NSLog(@"navipopview dealloc");
}

@end
