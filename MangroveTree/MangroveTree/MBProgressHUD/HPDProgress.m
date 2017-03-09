//
//  HPDProgress.m
//  HePanDai2_0
//
//  Created by HePanDai on 14-8-6.
//  Copyright (c) 2014年 HePanDai. All rights reserved.
//

#import "HPDProgress.h"

@implementation HPDProgress

+ (HPDProgress *)defaultProgressHUD
{
    static HPDProgress *progress = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progress  = [[HPDProgress alloc] init];
    });
    return progress;
}

- (void)showHUDOnView:(UIView *)view message:(NSString *)message hideAfterDelay:(NSTimeInterval)delay
{
    [self showHUDOnView:view message:message];
    [self hideAfterDelay:delay];
}

- (void)showHUDOnView:(UIView *)view message:(NSString *)message
{
    if (!self.progressHud) {
        _progressHud = [[MBProgressHUD alloc] initWithView:view];
        _progressHud.mode = MBProgressHUDModeIndeterminate;
    }
    _progressHud.labelText = message;
    _progressHud.removeFromSuperViewOnHide = YES;
    [view addSubview:_progressHud];
//    [_progressHud show:YES];
}

- (void)showCoustomOnView:(UIView *)view message:(NSString *)message hideAfterDelay:(NSTimeInterval)delay complete:(HideComplateBlock)block
{
    [self showCoustomOnView:view message:message];
    [self hideAfterDelay:delay complete:block];
}

- (void)showCoustomOnView:(UIView *)view message:(NSString *)message hideAfterDelay:(NSTimeInterval)delay
{
    [self showCoustomOnView:view message:message];
    [self hideAfterDelay:delay];
}
- (void)showCoustomOnView:(UIView *)view message:(NSString *)message
{
    _progressHud = [[MBProgressHUD alloc] initWithView:view];
    _progressHud.mode = MBProgressHUDModeCustomView;
    _progressHud.labelText = message;
    _progressHud.removeFromSuperViewOnHide = YES;
    [view addSubview:_progressHud];
//    [_progressHud show:YES];
}

- (void)holdMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay complete:(HideComplateBlock)complete
{
    [self holdMessage:message];
    [self hideAfterDelay:delay complete:complete];
}

- (void)holdMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay
{
    [self holdMessage:message];
    [self hideAfterDelay:delay];
}

- (void)holdMessage:(NSString *)message
{
    _progressHud.mode = MBProgressHUDModeCustomView;
    _progressHud.labelText = message;
}

- (void)hide
{
    [_progressHud hide:YES];
}
- (void)hideAfterDelay:(NSTimeInterval)delay
{
    [_progressHud hide:YES afterDelay:delay];
}

- (void)hideAfterDelay:(NSTimeInterval)delay complete:(HideComplateBlock)complete
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
        complete();
    });
}


@end
