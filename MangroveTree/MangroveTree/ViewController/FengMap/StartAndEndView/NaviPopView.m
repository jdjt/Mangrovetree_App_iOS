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
@property (nonatomic, assign) BOOL enableEnterIndoor;

@end

@implementation NaviPopView

+ (instancetype)naviPopView
{
	 NaviPopView * view = [[NSBundle mainBundle] loadNibNamed:@"NaviPopView" owner:nil  options:nil][0];
	view.alpha = 0.0f;
    [view.startNavBtn loginStyle];
    [view.enterIndoorBtn loginStyle];
	return view;
}

- (void)hide
{
	__weak typeof(self)wSelf = self;
	[UIView animateWithDuration:0.4f animations:^{
		wSelf.alpha = 0.0f;
        wSelf.timeLabel.text = @"";
        wSelf.lengthLabel.text = @"";
	}];
}

- (void)show
{
	self.alpha = 0.9f;
    self.hidden = NO;
	__weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.4f animations:^{
        CGRect rect = self.frame;
        wSelf.frame = CGRectMake(0, kScreenHeight-rect.size.height-49, kScreenWidth, rect.size.height);
    } completion:^(BOOL finished) {
        [wSelf setupBottomView];
    }];
}
- (IBAction)switchStartAndEndBtnClick:(id)sender {
	if ([self.delegate respondsToSelector:@selector(switchStartAndEnd)]) {
		[self.delegate switchStartAndEnd];
	}
	
//	[self.startPointBtn setTitle:self.endPointBtn.titleLabel.text forState:UIControlStateNormal];
//	[self.endPointBtn setTitle:@"我的位置" forState:UIControlStateNormal];
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
    self.enableEnterIndoor = NO;
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
            self.enableEnterIndoor = YES;
            _indoorMapID = info.map_mid;
        }
    }
    
    //判断是否能够进入室内
    if (!self.enableEnterIndoor) {
//        [self.enterIndoorBtn setImage:[UIImage imageNamed:@"noEnter"] forState:UIControlStateNormal];
        self.enterIndoorBtn.enabled = NO;
    }
    else
    {
//        [self.enterIndoorBtn setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
        self.enterIndoorBtn.enabled = YES;
    }
    //设置能否进入室内的布局
    [self setupBottomView];
    
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
//    [self.endPointBtn setTitle:name forState:UIControlStateNormal];

}
- (void)setupModelInfoByNodel:(QueryDBModel *)model
{
    self.enableEnterIndoor = NO;
    [self setupBottomView];
}

- (void)setupBottomView
{
    self.enterIndoorBtn.hidden = !self.enableEnterIndoor;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = self.frame;
        frame.size.height = self.enableEnterIndoor == YES ? 94: 74;
        self.frame = frame;
        self.startNavBtn.frame = CGRectMake(self.enableEnterIndoor == YES ? 27:kScreenWidth-27-self.startNavBtn.width, self.enableEnterIndoor == YES ? 38 : (self.height-self.startNavBtn.height)/2,  self.startNavBtn.width, self.enableEnterIndoor == YES ? 38 : 43);
        self.powerLabel.frame = CGRectMake(self.enableEnterIndoor == YES ? kScreenWidth-27-self.powerLabel.width : 27, self.enableEnterIndoor == YES ? 6 : 6*2+self.timeLabel.height , self.powerLabel.width, self.powerLabel.height);
        self.powerLabel.bottom = self.enableEnterIndoor == YES ? self.timeLabel.bottom: self.startNavBtn.bottom;
        self.enterIndoorBtn.frame = CGRectMake(self.startNavBtn.right +30, 38, self.enterIndoorBtn.width, self.enterIndoorBtn.height);
    }];
}

- (void)dealloc
{
	NSLog(@"navipopview dealloc");
}

@end
