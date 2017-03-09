//
//  CategoryView.h
//  FMMangroveMapView
//
//  Created by fengmap on 16/9/21.
//  Copyright © 2016年 FengMap. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CategoryBtnClickBlock)(NSInteger tag, BOOL buttonSelected);

@interface CategoryView : UIView
@property (strong, nonatomic) IBOutlet UIView *serviceView;
@property (strong, nonatomic) IBOutlet UIView *shopView;
@property (strong, nonatomic) IBOutlet UIView *foodView;
@property (strong, nonatomic) IBOutlet UIView *routeView;
@property (strong, nonatomic) IBOutlet UIView *zoneView;
@property (strong, nonatomic) IBOutlet UIButton *serviceBtn;
@property (strong, nonatomic) IBOutlet UIButton *shopBtn;
@property (strong, nonatomic) IBOutlet UIButton *foodBtn;
@property (strong, nonatomic) IBOutlet UIButton *routeBtn;
@property (strong, nonatomic) IBOutlet UIButton *zoneBtn;
@property (nonatomic, copy) CategoryBtnClickBlock  categoryBtnClickBlock;

+ (instancetype)categoryView;

@end
