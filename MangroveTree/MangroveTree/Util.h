/**
 Copyright (c) 2012 Mangrove. All rights reserved.
 Author:mars
 Date:2014-10-24
 Description: 工具
 */
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface Util : NSObject

/**
 * @abstract 获取uuid
 */
+ (NSString*)getUUID;

+ (NSString*) macaddress;

/**
 * @abstract 获取当前时间
 */
+ (NSTimeInterval)timestamp;

/**
 * @abstract 判断邮箱
 */
+(BOOL)isValidateEmail:(NSString *)email;

/**
 * @abstract 判断手机号
 */
+(BOOL) isMobileNumber:(NSString *)mobileNum;
+(NSString *)EncodeUTF8Str:(NSString *)encodeStr;

/**
 * @abstract 获取mac地址
 */
+ (NSString*) getMacAdd;
+ (NSString *)getTimeNow;
/**
 * @abstract 根据三色值生成图片
 */
+ (UIImage *) createImageWithColor: (UIColor *) color;

/**
 * @abstract 判断字符床是否为空
 */
+(Boolean) isEmptyOrNull:(NSString *) str;

/**
 * @abstract 判断当前是否有网络
 */
+ (BOOL) isConnectionAvailable;

/**
 * @abstract 替换服务器
 */
+ (NSInteger)SelectTheServerUrl;

/**
 * @abstract 计算明天的日期
 */
+ (NSDate *)startDate:(NSDate *)date offsetDay:(int)numDays;

/**
 * @abstract 判断最新消息
 */
- (BOOL)LatestNews:(NSString *)messageCode;

/**
 * @abstract 当前消息是否阅读
 */
- (void)WhetherOrNotToread:(NSString *)messageCode isRead:(NSString *)isread;

/**
 * @abstract 判断是否有未读消息
 */
- (BOOL)UnreadMessage;

/**
 * @abstract 获取当前网络状态
 */
+ (int)getCurrentNetworkStatus;

+ (CIImage *)createQRForString:(NSString *)qrString;

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

+ (NSString *)getIPAddress;

+ (NSString *)genSign:(NSDictionary *)signParams;

+ (NSString *)md5:(NSString *)str;

+ (BOOL)locationServicesEnabled;

+ (id)analysisJsonByfileName:(NSString *)fileName fileType:(NSString *)type;

@end
