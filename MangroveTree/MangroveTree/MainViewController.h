//
//  MainViewController.h
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/3/9.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameViewController.h"
#import "UserViewController.h"

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *UserView;
@property (weak, nonatomic) IBOutlet UIView *MapView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *UserContants;

@property (nonatomic, strong) FrameViewController * frameViewController;
@property (nonatomic, strong) UserViewController * userViewController;

@end
