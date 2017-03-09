//
//  NetWorkHelp.h
//  mgmanager
//
//  Created by 刘超 on 15/5/15.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkHelp : NSObject
/**
 * @abstract 比较网络请求时间，确定是否发送网络请求
 * @param ident 接口标示
 *  ByUser 是否是用户主动刷新
 */
- (BOOL)ComparingNetworkRequestTime:(NSString *)ident ByUser:(BOOL)byUser;


@end
