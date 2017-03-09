//
//  BaseCollectionViewCell.h
//  FeiFanWandaDemo
//
//  Created by Haoyu Wang on 16/6/27.
//  Copyright © 2016年 fengmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)setImage:(UIImage *)image andLabelText:(NSString *)text;
@end
