//
//  GradeViewController.h
//  MangroveTree
//
//  Created by liuchao on 2017/4/25.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ClickType)
{
    ClickType_Cancel = 0,
    ClickType_Submit = 1,
};

typedef void(^BlockClick)(ClickType clickType,NSInteger score);

@interface GradeViewController : UIViewController

+ (instancetype)initWithGradeInfor:(DBCallTask *)gradeInfor withClick:(BlockClick)click;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end
