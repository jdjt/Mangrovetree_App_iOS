//
//  HeadView.h
//  mgmanager
//
//  Created by fengmap on 16/8/14.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView
@property (strong, nonatomic) IBOutlet UIButton *myPositionBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectedPositionBtn;

+ (instancetype)headView;

@end
