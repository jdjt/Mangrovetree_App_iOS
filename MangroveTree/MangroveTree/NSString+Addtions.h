//
//  NSString(Addtions).h
//  mgmanager
//
//  Created by Sun Peng on 15/5/12.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addtions)

/**
 * @abstract 根据字符串长度、字体大小和宽度计算动态高度
 * @param text 输入字符串长度
 * @param font 使用字体大小
 */
+ (CGFloat)heightFromString:(NSString*)text withFont:(UIFont*)font constraintToWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
