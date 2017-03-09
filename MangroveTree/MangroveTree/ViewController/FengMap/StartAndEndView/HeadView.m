//
//  HeadView.m
//  mgmanager
//
//  Created by fengmap on 16/8/14.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (IBAction)myPositionBtnClick:(id)sender {
}

- (IBAction)selectedPositionBtnClick:(id)sender {
}

+ (instancetype)headView
{
	HeadView * view = [[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:nil options:nil][0];
	
	return view;
}

@end
