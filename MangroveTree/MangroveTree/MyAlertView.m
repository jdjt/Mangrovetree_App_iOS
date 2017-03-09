//
//  MyAlertView.m
//  Safety
//
//  Created by shaoxiang on 14-6-26.
//  Copyright (c) 2014年 shaoxiang. All rights reserved.
//

#import "MyAlertView.h"
@implementation MyAlertView

+(void)showDialog:(NSString *)msg{
    GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"提示"          message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil,nil];
    alert.style = GRAlertStyleInfo;
    [alert show];
}

+(void)showAlert:(NSString*)warning{
    GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"提示"
                                                     message:warning
                                                    delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
    alert.style = GRAlertStyleInfo;
    [alert show];
}

@end
