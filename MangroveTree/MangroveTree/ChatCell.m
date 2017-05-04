//
//  ChatCell.m
//  MangroveTree
//
//  Created by liuchao on 2017/4/13.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "ChatCell.h"
#import "PureLayout.h"

@interface ChatCell ()

@end

@implementation ChatCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [self addView];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addView];
    }
    return self;
}
- (void)addView
{

}
- (void)setModel:(NSDictionary *)model
{
    if (_model != model)
    {
        _model = model;
        self.contentLabel.text = self.model[@"text"];
        self.arealabel.text = [NSString stringWithFormat:@"呼叫区域:%@",self.model[@"are"]];
        self.timelabel.text = self.model[@"time"];

    }
}
- (void)changAgainLocationWithReset:(BOOL)reset
{
    if (reset == YES)
    {
        self.helpImage.hidden = NO;
        self.conrentConstraint.constant = 32;
    }else
    {
        self.helpImage.hidden = YES;
        self.conrentConstraint.constant = 0;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
