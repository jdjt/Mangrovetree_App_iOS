//
//  UILabel+AddtionString.m
//  mgmanager
//
//  Created by fengmap on 16/9/9.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "UILabel+AddtionString.h"

@implementation UILabel (AddtionString)

+ (CGFloat)getWidthByContent:(NSString *)content font:(UIFont *)font
{
	UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 10)];
	label.text = content;
	label.font = font;
	[label sizeToFit];
	return label.frame.size.width;
}

@end
