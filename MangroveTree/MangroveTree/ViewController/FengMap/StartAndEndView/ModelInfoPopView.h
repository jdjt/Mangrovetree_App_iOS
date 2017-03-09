//
//  ModelInfoPopView.h
//  mgmanager
//
//  Created by fengmap on 16/8/11.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMKGeometry.h"

@class FMKExternalModel;

@protocol ModelInfoPopViewDelegate <NSObject>

@optional
- (void)enterIndoorMapBtnClick:(NSString *)modelFid;

- (void)goHere:(FMKGeoCoord)coord;

@end

@interface ModelInfoPopView : UIView
@property (strong, nonatomic) IBOutlet UILabel *modelName;
@property (strong, nonatomic) IBOutlet UIButton *goHereBtn;
@property (strong, nonatomic) IBOutlet UIButton *enterIndoorBtn;
@property (strong, nonatomic) IBOutlet UIView *topBackgroudView;
@property (strong, nonatomic) IBOutlet UIView *backGroudView;
@property (strong, nonatomic) IBOutlet UIView *separateView;
@property (weak, nonatomic) id<ModelInfoPopViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *modelPositionLabel;
@property (strong, nonatomic) IBOutlet UIButton *detailBtn;


+ (instancetype)modelInfoPopView;

- (void)setupInfoByModel:(FMKExternalModel *)model;

//- (void)show;
//
//- (void)hide;

@end
