//
//  Util.m
//  CollapseClickDemo
//
//  Created by shaoxiang on 14-6-15.
//  Copyright (c) 2014年 Ben Gordon. All rights reserved.
//

#import "Util.h"

#define hll_color(r,g,b,a) [UIColor colorWithRed:(float)r/255.f green:(float)g/255.f blue:(float)b/255.f  alpha:a]

@interface UIColor (HLLAdditions)

//the background color for the current cell
+ (UIColor*)hll_backgroundColorForIndex:(NSUInteger)index;

@end

static NSString* macadd;

@implementation Util

+ (NSString *)getUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(NSString*)CFBridgingRelease(uuid_string_ref)];
    
    
    //    CFRelease(uuid_string_ref);
    return uuid;
}

/*************************************************
 Function:       // getMacAdd
 Description:    // 获取本机mac地址
 Input:          //
 Return:         // int 个数
 Others:         //
 *************************************************/
+(NSString*)getMacAdd{
    if (!macadd) {
        macadd = [self macaddress];
    }
    return macadd;
}

//+ (NSString *)getIPAddress
//{
//    NSString *address = @"error";
//    struct ifaddrs *interfaces = NULL;
//    struct ifaddrs *temp_addr = NULL;
//    int success = 0;
//    
//    // retrieve the current interfaces - returns 0 on success
//    success = getifaddrs(&interfaces);
//    if (success == 0) {
//        // Loop through linked list of interfaces
//        temp_addr = interfaces;
//        while (temp_addr != NULL) {
//            if( temp_addr->ifa_addr->sa_family == AF_INET) {
//                // Check if interface is en0 which is the wifi connection on the iPhone
//                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
//                    // Get NSString from C String
//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                }
//            }
//            
//            temp_addr = temp_addr->ifa_next;
//        }
//    }
//    
//    // Free memory
//    freeifaddrs(interfaces);
//    
//    return address;
//}

+ (NSString*) macaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    mib[0] = CTL_NET;
    
    mib[1] = AF_ROUTE;
    
    mib[2] = 0;
    
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    return [outstring uppercaseString];
    
}
/*************************************************
 Function:       // timestamp
 Description:    // 获取时间戳
 Input:          //
 Return:         // timestamp 时间戳
 Others:         //
 *************************************************/
+ (NSTimeInterval)timestamp{
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    return timestamp;
}
/*************************************************
 Function:       // isValidateEmail
 Description:    // 邮箱验证
 Input:          // email 被检测文本
 Return:         //
 Others:         //
 *************************************************/
/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
/*************************************************
 Function:       // isValidateEmail
 Description:    // 手机号验证
 Input:          // mobileNum 被检测文本
 Return:         //
 Others:         //
 *************************************************/
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    if ([mobileNum length] != 11) {//不为11位 不是手机号
        return NO;
    }
    
    //运用正则匹配
    NSString *patternStr = [NSString stringWithFormat:@"^(0?1[3578]\\d{9})$|^((0(10|2[1-3]|[3-9]\\d{2}))?[1-9]\\d{6,7})$"];
    NSRegularExpression *regularexpression=[[NSRegularExpression alloc]initWithPattern:patternStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
    NSUInteger numberOfMatch = [regularexpression numberOfMatchesInString:mobileNum
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, mobileNum.length)];
    if (numberOfMatch > 0) {
        return YES;
    }
    
    return NO;
}
/*************************************************
 Function:       // getTimeNow
 Description:    // 获取当前时间
 Input:          //
 Return:         // timeNow当前时间
 Others:         //
 *************************************************/
+(NSString *)getTimeNow
{
    NSDate* date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString* timeNow = [formatter stringFromDate:date];
    return timeNow;
}
/*************************************************
 Function:       // base64forData
 Description:    // 将数据转成base64
 Input:          //
 Return:         // theData 被转换数据
 Others:         //
 *************************************************/
+ (NSString*)base64forData:(NSData*)theData {
	
	const uint8_t* input = (const uint8_t*)[theData bytes];
	NSInteger length = [theData length];
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
	NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
		for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
#pragma mark -
#pragma mark Encode Chinese to ISO8859-1 in URL
+(NSString *)EncodeUTF8Str:(NSString *)encodeStr{
    CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");
    NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingUTF8));
    NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8));
    return newStr;
}
#pragma mark -根据颜色生成相应的图片
+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 32.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark -判断是否为空
+(Boolean) isEmptyOrNull:(NSString *) str
{
    if (!str) {// null object
        return true;
    }else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return true;
        }else if([trimedString isEqualToString:@"null"]){
            // is neither empty nor null
            return true;
        }else if([trimedString isEqualToString:@"(null)"]){
            // is neither empty nor null
            return true;
        }else if([trimedString isEqualToString:@"<null>"]){
            // is neither empty nor null
            return true;
        }else {
            return false;
        }
    }
}

+ (BOOL)isConnectionAvailable
{
    BOOL isExistenceNetwork = YES;
    switch ([AppDelegate sharedDelegate].networkStatus)
    {
        case AFNetworkReachabilityStatusNotReachable:
            isExistenceNetwork = NO;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        default:
            break;
    }
    return isExistenceNetwork;
}

+ (NSInteger)SelectTheServerUrl
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"NetworkInterface.plist"];
    NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    
    NSString *vserStr = [dataDic objectForKey:@"SwitchServer"];
    if (vserStr == nil || [vserStr isEqualToString:@"0"] || [vserStr isEqualToString:@""])
        return 0;
    else if ([vserStr isEqualToString:@"1"])
        return 1;
    return 2;
}

+ (NSDate *)startDate:(NSDate *)date offsetDay:(int)numDays
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:date options:0];
}

// 判断最新消息

- (BOOL)LatestNews:(NSString *)messageCode
{
    NSMutableDictionary *dic = [self getDocumentsDirectory];
    NSMutableDictionary *messageDic = [dic objectForKey:@"message"];
    
    if (![messageDic[@"messageCode"] isEqualToString:messageCode])
    {
        [messageDic setObject:messageCode forKey:@"messageCode"];
        [messageDic setObject:@"0" forKey:@"isread"];
        [dic setObject:messageDic forKey:@"message"];
        [self writeDataToLocationToPlist:dic];
        return YES;
    }
    else
    {
        if ([dic[@"isread"] isEqualToString:@"0"])
            return YES;
        else
            return NO;
    }
}

// 当前消息是否阅读

- (void)WhetherOrNotToread:(NSString *)messageCode isRead:(NSString *)isread
{
    NSMutableDictionary *dic = [self getDocumentsDirectory];
    NSMutableDictionary *messageDic = dic[@"message"];
    if ([isread isEqualToString:@"1"] && [messageCode isEqualToString:messageDic[@"messageCode"]])
    {
        [messageDic setObject:@"1" forKey:@"isread"];
        [dic setObject:messageDic forKey:@"message"];
        [self writeDataToLocationToPlist:dic];
    }
}

// 判断是否有未读消息

- (BOOL)UnreadMessage
{
    NSMutableDictionary *dic = [self getDocumentsDirectory];
    NSString *isread = [dic objectForKey:@"isread"];
    
    if ([isread isEqualToString:@"0"])
        return NO;
    else
        return YES;
}

// 获取消息字典

- (NSMutableDictionary *)getDocumentsDirectory
{
    NSString *plistPath = [self AccessToLocalFilePath];
    NSMutableDictionary *plistDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    NSMutableDictionary *dic = [plistDic objectForKey:@"message"];
    
    // 如果本地plist文件没有消息记录，则新建一个消息字典
    if ([dic allKeys] == 0)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"messageCode",@"",@"isread", nil];
        [plistDic setObject:dic forKey:@"message"];
        [plistDic writeToFile:plistPath atomically:YES];
    }
    return plistDic;
}

// 获取本地文件路径

- (NSString *)AccessToLocalFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"NetworkInterface.plist"];
    
    return plistPath;
}

- (void)writeDataToLocationToPlist:(NSMutableDictionary *)dataDic
{
    NSString *plistPath = [self AccessToLocalFilePath];
    [dataDic writeToFile:plistPath atomically:YES];
//    NSLog(@"%@",dataDic);
}

// 获取当前网络状态
+ (int)getCurrentNetworkStatus
{
    int netWorkStatus = 0;
     switch ([AppDelegate sharedDelegate].networkStatus)
     {
         case AFNetworkReachabilityStatusNotReachable:
             netWorkStatus = 0;
             break;
         case AFNetworkReachabilityStatusReachableViaWWAN:
             netWorkStatus = 2;
             break;
         case AFNetworkReachabilityStatusReachableViaWiFi:
             netWorkStatus = 1;
             break;
         default:
             break;
     }
    return netWorkStatus;
}

//// 根据floorid获取mallid
//+ (NSNumber *)getMallIDFromFloorIDWithLocation:(YTLocation *)location
//{
//    NSNumber *mallID = @(61);
//    if (location.floorID.integerValue >= 1061 && location.floorID.integerValue <= 1081) {
//        mallID = @(62);
//    }else if (location.floorID.integerValue == 1587 || location.floorID.integerValue == 1588 || (location.floorID.integerValue >= 1608 && location.floorID.integerValue <= 1626)) {
//        mallID = @(109);
//    }else if (location.floorID.integerValue >= 1654 && location.floorID.integerValue <= 1660) {
//        mallID = @(114);
//    }else if ((location.floorID.integerValue >= 1837 && location.floorID.integerValue <= 1855) ||
//              location.floorID.integerValue == 1833 || location.floorID.integerValue == 1712 ||
//              location.floorID.integerValue == 1713) {
//        mallID = @(48);
//    }else if (location.floorID.integerValue >= 1809 && location.floorID.integerValue <= 1830) {
//        mallID = @(135);
//    }
//    
//    return mallID;
//}
//+ (NSString *)getMallNameWithMallId:(NSNumber *)mallId
//{
//    NSString *titleName = nil;
//    switch (mallId.integerValue)
//    {
//        case 61:
//            titleName = @"三亚湾红树林度假世界";
//            break;
//        case 60:
//            titleName = @"菩提酒店";
//            break;
//        case 114:
//            titleName = @"国际会展中心";
//            break;
//        case 62:
//            titleName = @"椰林酒店";
//            break;
//        case 65:
//            titleName = @"木棉酒店A";
//            break;
//        case 66:
//            titleName = @"木棉酒店B";
//            break;
//        case 109:
//            titleName = @"皇后棕酒店";
//            break;
//        case 48:
//            titleName = @"棕榈酒店";
//            break;
//        case 135:
//            titleName = @"大王棕酒店";
//            break;
//        default:
//            titleName = @"三亚湾红树林度假世界";
//            break;
//    }
//    return titleName;
//}
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (CIImage *)createQRForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}
#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue
{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}
+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+ (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    const char *ptr = [signString UTF8String];
    
    int i =0;
    unsigned int len = (unsigned int) strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *result = [NSString stringWithString:hex];
    NSLog(@"--- Gen sign: %@", result);
    return result;
}
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+ (BOOL)locationServicesEnabled
{
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        NSLog(@"手机gps定位已经开启");
        return YES;
    } else {
        NSLog(@"手机gps定位未开启");
        return NO;
    }
}

+ (id)analysisJsonByfileName:(NSString *)fileName fileType:(NSString *)type
{
    NSString *file = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    
    NSData *data=[NSData dataWithContentsOfFile:file];
    NSError *error;
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
    return jsonObject;
}


@end
