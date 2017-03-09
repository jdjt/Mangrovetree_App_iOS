//
//  MTBaseNetworkController.m
//  mgmanager
//
//  Created by 罗禹 on 16/7/5.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "MTBaseNetworkController.h"

@interface MTBaseNetworkController ()

@end

@implementation MTBaseNetworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)dealloc {
    if (self.hud) {
        [self.hud hide:YES];
        [self.hud removeFromSuperview];
    }
    [[MTRequestNetwork defaultManager] cancleAllRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MTRequestNetwork defaultManager]registerDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[MTRequestNetwork defaultManager] removeDelegate:self];
}

#pragma mark -  RequestNetWorkDelegate 协议方法

- (void)startRequest:(MTNetwork *)manager
{
    if (!self.hud)
    {
        self.hud = [[MBProgressHUD alloc] initWithWindow:[AppDelegate sharedDelegate].window];
        [[AppDelegate sharedDelegate].window addSubview:self.hud];
        self.hud.labelText = @"正在加载";
        [self.hud hide:NO];
        [self.hud show:YES];
    }
    else
    {
        [self.hud hide:YES];
        [self.hud removeFromSuperview];
        self.hud = [[MBProgressHUD alloc] initWithWindow:[AppDelegate sharedDelegate].window];
        [[AppDelegate sharedDelegate].window addSubview:self.hud];
        self.hud.labelText = @"正在加载";
        [self.hud hide:NO];
        [self.hud show:YES];
    }
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self.hud];
    [self.hud hide:YES];
}

- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas {
    [self.hud hide:YES];
    [self.hud removeFromSuperview];
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task  responseCode:(NSString *)code withMessage:(NSString *)msg {
    [self.hud hide:YES];
    [self.hud removeFromSuperview];
}

@end
