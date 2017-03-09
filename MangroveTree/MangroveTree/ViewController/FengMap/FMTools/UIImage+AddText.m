//
//  UIImage+AddText.m
//  mgmanager
//
//  Created by fengmap on 16/9/1.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "UIImage+AddText.h"

@implementation UIImage (AddText)

+ (UIImage *)addNumberText:(NSString *)text
{
	UIImage * image = [UIImage imageNamed:@"line_icon_fun"];
	
	CGSize size= CGSizeMake (image. size . width , image. size . height );
	
	UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
	
	[image drawAtPoint : CGPointMake ( 0 , 0 )];
	
	CGContextRef context= UIGraphicsGetCurrentContext ();
	
	CGContextDrawPath (context, kCGPathStroke );
	
	UIFont* theFont = [UIFont systemFontOfSize:13];
	
	CGSize textSize = [text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:@{ NSFontAttributeName :theFont, NSForegroundColorAttributeName :[ UIColor whiteColor ]} context:nil].size;
	
	
	[text drawAtPoint : CGPointMake ( image.size.width*0.5-textSize.width/2 ,image.size.height* 0.1 ) withAttributes : @{ NSFontAttributeName :theFont, NSForegroundColorAttributeName :[ UIColor whiteColor ] } ];
	
	UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
	
	UIGraphicsEndImageContext ();
	
	return newImage;
}
@end
