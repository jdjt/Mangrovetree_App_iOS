//
//  ChooseFloorScrollView.h
//  HuaCeUniversalDemo
//
//  Created by fengmap on 16/3/30.
//  Copyright © 2016年 fengmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseFloorScrollViewDelegate <NSObject>

- (void)buttonClick:(NSInteger)page;

@end

@interface ChooseFloorScrollView : UIView

@property (nonatomic ,weak) id<ChooseFloorScrollViewDelegate> delegate;

@property (nonatomic ,strong)NSMutableArray *tagButtons;

- (instancetype)initWithGids:(NSArray *)gids;

- (void)createScrollView:(NSArray *)gids;

- (void)updateScrollViewContentOffsetWithPgae:(NSInteger)page;

- (void)updateScrollViewContentOffsetByIndex:(NSInteger)index;

@end
