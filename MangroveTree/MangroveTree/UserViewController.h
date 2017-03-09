//
//  UserViewController.h
//  mgmanager
//
//  Created by 苏智 on 15/4/20.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UITableViewController

/**
 * @abstract 当前选择的酒店名称
 */
@property (strong, nonatomic) NSString *selectedLocationName;
@property (nonatomic, retain) DBUserLogin *user;

@end
