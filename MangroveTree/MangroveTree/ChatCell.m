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

@property (nonatomic, strong) UILabel *mTitle;
@property (nonatomic, strong) UILabel *mText;
@property (nonatomic, strong) UILabel *mTime;
@property (nonatomic, strong) UILabel *mAreTitle;
@property (nonatomic, strong) UIButton *againButton;

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
    self.mTitle = [[UILabel alloc] init];
    self.mTitle.text = @"呼叫内容:";
    self.mTitle.font = [UIFont systemFontOfSize:15.0f];
    self.mTitle.textColor = [UIColor colorWithHexString:@"#484b59"];
    [self.contentView addSubview:self.mTitle];
    [self.mTitle autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:18];
    [self.mTitle autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:18];
    [self.mTitle autoSetDimension:ALDimensionWidth toSize:kScreenWidth/4*3];
    
    self.againButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.againButton setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
//    [self.contentView addSubview:self.againButton];
    
    self.mText = [[UILabel alloc] init];
    self.mText.numberOfLines = 0;
    self.mText.clipsToBounds = YES;
    self.mText.layer.cornerRadius = 3.0f;
    self.mText.text = self.model[@"text"];
    self.mText.font = [UIFont systemFontOfSize:19.0f];
    self.mText.textColor = [UIColor colorWithHexString:@"#5a5a5a"];
    self.mText.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.mText];
    
    [self.mText autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:18];
    [self.mText autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mTitle withOffset:12];
    [self.mText autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:18];
    
    self.mAreTitle = [[UILabel alloc] init];
    self.mAreTitle.text = [NSString stringWithFormat:@"呼叫区域:%@",self.model[@"are"]];
    self.mAreTitle.font = [UIFont systemFontOfSize:15.0f];
    self.mAreTitle.textColor = [UIColor colorWithHexString:@"#484b59"];
    [self.contentView addSubview:self.mAreTitle];
    [self.mAreTitle autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:18];
    [self.mAreTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mText withOffset:14];
    
    self.mTime = [[UILabel alloc] init];
    self.mTime.text = self.model[@"time"];
    self.mTime.font = [UIFont systemFontOfSize:12.0f];
    self.mTime.textColor = [UIColor colorWithHexString:@"#ed8256"];
    [self.contentView addSubview:self.mTime];
    [self.mTime autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:18];
    [self.mTime autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mText withOffset:16];

}
- (void)setModel:(NSDictionary *)model
{
    if (_model != model)
    {
        _model = model;
    }
    self.mText.text = self.model[@"text"];
    self.mAreTitle.text = [NSString stringWithFormat:@"呼叫区域:%@",self.model[@"are"]];
    self.mTime.text = self.model[@"time"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
