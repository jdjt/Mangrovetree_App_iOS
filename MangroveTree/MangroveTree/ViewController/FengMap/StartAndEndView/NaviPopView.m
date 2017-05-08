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
    BOOL _enableEnterIndoor;
}

@end

@implementation NaviPopView

+ (instancetype)naviPopView
{
	 NaviPopView * view = [[NSBundle mainBundle] loadNibNamed:@"NaviPopView" owner:nil  options:nil][0];
	view.alpha = 0.0f;
    [view.startNavBtn loginStyle];
    [view.enterIndoorBtn loginStyle];
    view.startNavBtn.frame = CGRectMake( 27,38,(kScreenWidth-27*2-30)/2, 38 );
    view.enterIndoorBtn.frame = CGRectMake(view.startNavBtn.right +30, 38, (kScreenWidth-27*2-30)/2, 38);
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
- (void)setupInfoByModel:(NSString *)fid
{
    _enableEnterIndoor = NO;
//    _modelFid = fid;
    if (!_indoorMapInfos) {
        _indoorMapInfos = [ParserJsondata  parserIndoorMap];
    }
    _modelFid = fid;
    //找到对应的室内地图ID
    for (IndoorMapInfo * info in _indoorMapInfos) {
        if ([fid isEqualToString:info.model_fid]) {
            _enableEnterIndoor = YES;
            _indoorMapID = info.map_mid;
        }
    }
    
    //设置能否进入室内的布局
    [self setupBottomView];
    
    QueryDBModel * dbModel = [[DBSearchTool shareDBSearchTool] queryModelByFid:fid];
    //设置模型信息弹框
    [self setupModelInfoNameByNodel:dbModel];
    
}

- (void)setupModelInfoNameByNodel:(QueryDBModel *)model
{
    NSString *name = @"暂无名称";

    if ([model.name isEqualToString:@""])
    {
       name = @"暂无名称";
    }
    else
    {
        name = model.name;
    }
    
}
- (void)setupModelInfoByNodel:(QueryDBModel *)model
{
    _enableEnterIndoor = NO;
    [self setupBottomView];
}

- (void)setupBottomView
{
    self.enterIndoorBtn.hidden = !_enableEnterIndoor;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = self.frame;
        frame.size.height = _enableEnterIndoor == YES ? 94: 74;
        self.frame = frame;
        
        self.startNavBtn.frame = CGRectMake(_enableEnterIndoor == YES ? 27:kScreenWidth-27-self.startNavBtn.width, _enableEnterIndoor == YES ? 38 : (self.height-self.startNavBtn.height)/2,  self.startNavBtn.width, _enableEnterIndoor == YES ? 38 : 43);
        self.powerLabel.frame = CGRectMake(_enableEnterIndoor == YES ? kScreenWidth-27-self.powerLabel.width : 27, _enableEnterIndoor == YES ? 6 : 6*2+self.timeLabel.height , self.powerLabel.width, self.powerLabel.height);
        self.powerLabel.bottom = _enableEnterIndoor == YES ? self.timeLabel.bottom: self.startNavBtn.bottom;
        self.enterIndoorBtn.frame = CGRectMake(self.startNavBtn.right +30, 38, self.enterIndoorBtn.width, self.enterIndoorBtn.height);
        [self.startNavBtn setTitle:@"开始导航" forState:UIControlStateNormal];
        [self.enterIndoorBtn setTitle:@"进入室内" forState:UIControlStateNormal];
    }];
}

- (void)dealloc
{
	NSLog(@"navipopview dealloc");
}

@end
