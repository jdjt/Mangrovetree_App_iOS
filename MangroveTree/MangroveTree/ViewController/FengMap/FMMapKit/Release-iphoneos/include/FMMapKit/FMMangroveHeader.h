//
//  FMMangroveHeader.h
//  FMMapKit
//
//  Created by fengmap on 16/10/31.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#ifndef FMMangroveHeader_h
#define FMMangroveHeader_h

#define kGPSSingalStrongLimit 15.0f//GPS信号强条件
#define kGPSSingalWeakLimit 50.0f//GPS信号弱条件
#define kWIFIGPSSingalWeakLimit 30.0f//GPS信号弱条件
#define kEnterIndoorCount 4
#define kOutdoorCount 6
#define kGPSSingalWeakCount 3
#define kIndoorToOutCount 3//使用室内路径约束判断是否切地图
#define kIndoorToOutDistanceLimit 5.0f//室内切室外的距离值

#define kOutdoorMapID 79980
#define kLocalMacAddrKey @"kLocalMacAddrKey"

#define MYBUNDLE_NAME @ "FMBundle.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#endif /* FMMangroveHeader_h */
