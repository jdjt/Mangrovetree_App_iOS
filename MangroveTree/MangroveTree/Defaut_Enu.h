//
//  Defaut_Enu.h
//  MiLi
//
//  Created by choi on 13-4-13.
//  Copyright (c) 2013年 viewdidload. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>



typedef NS_ENUM(NSInteger, SYSTEMLANGUAGESTATE) {
    SYSTEMLANGUAGESTATECHINA = 0,//简体
    SYSTEMLANGUAGESTATEOLDCHINA,//繁体
    SYSTEMLANGUAGESTATEENGLISH,//英语
    SYSTEMLANGUAGESTATEOTHER,//其它
};



//判断iPhone5的代码
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


//判断retain屏的
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isNormalScreen ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size)) : NO)

//Documents 文件目录
#define Documents() [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

//设置RGB颜色
#define UIColorFromRGB(rgbValue,rgbalpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:rgbalpha]
#define UIColorWithRGBA(rgbred,rgbgreen,rgbblue,rgbalpha) [UIColor colorWithRed:rgbred/255.0 green:rgbgreen/255.0 blue:rgbblue/255.0 alpha:rgbalpha]

#define ISIOS7 ([[UIDevice currentDevice].systemVersion intValue] == 7)


#pragma mark C 函数
void setnavigtionBackbar(UIViewController *viewcontroller);

//view截图
UIImage *ImageWithView(UIView *view);
UIImage *ImageWithRect(UIView *view,CGRect rect);

//把resource资源拷到Document
void moveFileResourceofType(NSString *filename,NSString *type);
//Label高度
float LabelheightWithString(NSString *string,float font,float width);
float LabelheightWithStringF(NSString *string,UIFont *font,float width);
//Label宽度
float LabelwidthWithString(NSString *string,float font,float height);
float LabelwidthWithStringF(NSString *string,UIFont *font,float height);


//判断系统语言
SYSTEMLANGUAGESTATE systemlangyage();
//根据系统语言转变字体
NSString *stringbysystemlangyage(NSString *string);
//字体转换
NSString *gbToBig5(NSString *srcString);//简体转繁体
NSString *big5ToGb(NSString *srcString);//繁体转简体


//获取mac地址
NSString * macaddress();


#pragma mark-----
#pragma mark 扩展类

@interface NSMutableAttributedString(EasySetting)

// 设置某段字的颜色
- (void)setColor:(UIColor *)color Range:(NSRange)range;
// 设置某段字的字体
- (void)setFont:(UIFont *)font Range:(NSRange)range;
// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style Range:(NSRange)range;

@end


#pragma mark-----
#pragma mark 扩展类

@interface UIViewController (SHViewApi)

//高度
- (CGFloat)topOfViewOffset;
- (CGFloat)bottomOfViewOffset;

- (UIViewController *)contentViewController;//当前节点以上显示的页面

@end

@interface UIBarButtonItem(EasySetting)

+(UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor ;

+ (id)barButtonItemWithFrame:(CGRect)frame Image:(UIImage *)image Selected:(UIImage *)selectedImage Highlighted:(UIImage *)highlightedImage Target:(id)target Action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end











