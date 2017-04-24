//
//  UILabel+ChangeLineSpace.m
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/4/20.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "UILabel+ChangeLineSpace.h"

@implementation UILabel (ChangeLineSpace)

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space
{
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

@end
