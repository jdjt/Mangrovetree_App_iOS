//
//  BaseCollectionViewCell.m
//  FeiFanWandaDemo
//
//  Created by Haoyu Wang on 16/6/27.
//  Copyright © 2016年 fengmap. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setImage:(UIImage *)image andLabelText:(NSString *)text {
    self.imageView.image = image;
    self.label.text = text;
}

@end
