//
//  BaseCollectionView.h
//  FeiFanWandaDemo
//
//  Created by Haoyu Wang on 16/6/27.
//  Copyright © 2016年 fengmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseCollectionView;
@protocol BaseCollectionViewDelegate <NSObject>

- (void)baseCollectionView:(BaseCollectionView *)collectionView didSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BaseCollectionView : UICollectionView

@property (nonatomic, assign) id<BaseCollectionViewDelegate> delegateColl;

+ (instancetype)baseCollectionViewContentArray:(NSArray *)contentArray;
@end
