//
//  MapSearchViewController.h
//  seaerch
//
//  Created by Haoyu Wang on 16/6/27.
//  Copyright © 2016年 fengmap. All rights reserved.
//
// 地图查询

#import <UIKit/UIKit.h>

@protocol MapSearchViewControllerDelegate <NSObject>

/// 数组中为 MapSearchResultModel 对象
- (void)mapSearchViewSearchResult:(NSArray *)result isFoodMap:(BOOL)isFood;
@end

@interface MapSearchViewController : UIViewController

@property (nonatomic, copy) NSString *mapID;
@property (nonatomic, assign) NSInteger currentGroup;
@property (nonatomic, assign) id<MapSearchViewControllerDelegate> delegate;


@end
