//
//  BaseNavigationController.m
//  MangroveTree
//
//  Created by sjlh on 2017/3/15.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
    [self.navigationBar setBackgroundImage:[Util createImageWithColor:[UIColor colorWithRed:241.0/255 green:180.0/255 blue:90.0/255 alpha:1]] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
