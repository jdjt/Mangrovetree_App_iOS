//
//  NaviPopView.h
//  mgmanager
//
//  Created by fengmap on 16/8/11.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryDBModel.h"

typedef void(^StartNavi)();
typedef void(^SwitchStartAndEnd)();

@protocol NaviPopViewDelegate <NSObject>

- (void)enterIndoorMapBtnClick:(NSString *)modelFid;
@optional
- (void)startNavi;
- (void)switchStartAndEnd;

@end

@interface NaviPopView : UIView

@property (nonatomic, weak) id<NaviPopViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *powerLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lengthLabel;
@property (nonatomic, copy) StartNavi startNaviBlock;
@property (nonatomic, copy) SwitchStartAndEnd switchStartAndEndBlock;
@property (weak, nonatomic) IBOutlet UIButton *enterIndoorBtn;
@property (weak, nonatomic) IBOutlet UIButton *startNavBtn;


+ (instancetype)naviPopView;

- (void)setTimeByLength:(double)length;

- (void)setupInfoByModel:(NSString *)fid;
- (void)setupModelInfoByNodel:(QueryDBModel *)model;
- (void)setupBottomView;

- (void)hide;
- (void)show;

@end
