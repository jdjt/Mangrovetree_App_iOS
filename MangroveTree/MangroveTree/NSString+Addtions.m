//
//  NSString(Addtions).m
//  mgmanager
//
//  Created by Sun Peng on 15/5/12.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import "NSString+Addtions.h"

@implementation NSString (Addtions)

+ (CGFloat)heightFromString:(NSString*)text withFont:(UIFont*)font constraintToWidth:(CGFloat)width
{
    CGRect rect;
    
    // only support iOS 7+
    rect = [text boundingRectWithSize:CGSizeMake(width, 1000)
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:@{NSFontAttributeName:font}
                              context:nil];
    
    NSLog(@"%@: W: %.f, H: %.f", self, rect.size.width, rect.size.height);
    return rect.size.height;
}
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
