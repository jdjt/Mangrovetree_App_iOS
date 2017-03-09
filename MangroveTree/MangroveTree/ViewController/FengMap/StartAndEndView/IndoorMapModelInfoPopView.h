//
//  IndoorMapModelInfoPopVIew.h
//  mgmanager
//
//  Created by fengmap on 16/8/23.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QueryDBModel;

typedef void(^GoHereBlock)();

@interface IndoorMapModelInfoPopView : UIView
@property (strong, nonatomic) IBOutlet UILabel *modelNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *modelPositionLabel;
@property (strong, nonatomic) IBOutlet UIView *topBackView;
@property (strong, nonatomic) GoHereBlock goHereBlock;
- (IBAction)goHereBtnClick:(id)sender;

+ (instancetype)indoorMapModelInfoPopView;

- (void)setupModelName:(NSString *)modelName;

- (void)setupModelInfoByNodel:(QueryDBModel *)model;

- (void)show;

- (void)hide;

@end
