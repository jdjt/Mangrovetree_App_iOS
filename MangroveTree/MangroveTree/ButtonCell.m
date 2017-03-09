//
//  ButtonCell.m
//  mgmanager
//
//  Created by 苏智 on 15/5/13.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    [self.cellButton loginStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
