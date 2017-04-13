//
//  UIImage+AddText.h
//  mgmanager
//
//  Created by fengmap on 16/9/1.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AddText)

+ (UIImage *)addNumberText:(NSString *)text onImage:(UIImage *)image;

+ (UIImage *)getImageByName:(NSString *)imageName;

@end
