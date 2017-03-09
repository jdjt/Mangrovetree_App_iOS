//
//  NaviPopView.h
//  mgmanager
//
//  Created by fengmap on 16/8/11.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StartNavi)();
typedef void(^SwitchStartAndEnd)();

@protocol NaviPopViewDelegate <NSObject>

- (void)startNavi;
- (void)switchStartAndEnd;

@end

@interface NaviPopView : UIView

@property (nonatomic, weak) id<NaviPopViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *endPointBtn;
@property (strong, nonatomic) IBOutlet UIButton *startPointBtn;
@property (strong, nonatomic) IBOutlet UIButton *powerLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lengthLabel;
@property (nonatomic, copy) StartNavi startNaviBlock;
@property (nonatomic, copy) SwitchStartAndEnd switchStartAndEndBlock;

+ (instancetype)naviPopView;

- (void)setTimeByLength:(double)length;

- (void)hide;
- (void)show;

@end
