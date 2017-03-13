//
//  Const.h
//  FengMap
//
//  Created by fengmap on 15/8/30.
//  Copyright (c) 2015年 fengmap. All rights reserved.
//


#ifndef FengMap_Const_h
#define FengMap_Const_h

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define NavigationBar_Offset 64.0

#define kFloorButtonWidth 50
#define kFloorButtonHeight 45

#define BBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
#define BBColorTransparent(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.8f]

#define kNaviReturnBtnClick @"naviReturnBtnClick"
#define kNaviSearchBtnCLick @"naviSearchBtnClick"
#define kPostNaviResultInfo @"postNaviResultInfo"


#define kLocationSpace 10.0f
#define kTableViewHeight 225.0f
#define kSeaTableViewCellHeight 50.0f
#define kRouteViewHeight 200.0f
#define kNaviPopViewHeight 120.0f
#define kNaviTopViewHeight 110.0f
#define kOutdoorMapID  79980
#define kModelInfoPopViewHeight 92.0f
#define kLocBtnWidth 50.0f
#define kLocBtnHeight 50.0f
#define kFooterViewHeight 50.0f
#define kCellHeight 156.0f
#define kHistoryCellHeight 60.0f
#define kSwitchMapInfoViewHeight 44.0f

#define kHourCalorie 160.0f

#define kRouteDisplayViewHeight 200

//WIFI定位
#define kOutdoorURL  @"http://10.11.88.103:8073/ServiceApi.asmx/GetDetailMapInfoWithJson"
#define kOutdoorPositionURL @"http://10.11.88.103:8073/ServiceApi.asmx/GetTagStatusWithJson?tagMac="

/** 最高120 */
#define FMBottomMaxHeight 120
#define kNaviHeight 64

#endif
