//
//  MTBaseNetworkController.h
//  mgmanager
//
//  Created by 罗禹 on 16/7/5.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTRequestNetwork.h"
#import "MBProgressHUD.h"

@interface MTBaseNetworkController : UIViewController <MTRequestNetWorkDelegate>

@property (nonatomic, strong) MBProgressHUD * hud;

@end
