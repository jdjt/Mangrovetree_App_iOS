//
//  PointView.h
//  mgmanager
//
//  Created by fengmap on 16/8/14.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SETCOLOR(R, G, B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0f]

typedef void(^ButtonClickBlock)(UIButton * button, UILabel * label);

@protocol NumberLineViewDelegate;

@interface NumberLineView: UIView

@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UIButton *numPointBtn;
@property (weak, nonatomic) id<NumberLineViewDelegate>delegate;
@property (copy ,nonatomic) ButtonClickBlock buttonClick;

+ (instancetype)numberLineView;

@end
@protocol NumberLineViewDelegate <NSObject>

- (void)numberLineBtnClick:(NumberLineView *)view;

@end