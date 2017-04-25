//
//  DataManager+User.h
//  mgmanager
//
//  Created by 苏智 on 15/6/25.
//  Copyright (c) 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface DataManager (User)

/**
 * @abstract 查找登录信息
 */
- (DBUserLogin *)findUserLogInByCode:(NSString *)ticket;

/**
 * @abstract 查找是否登录
 */
- (BOOL)findUserLogIn;
/**
 * @abstract 查找本地是否有个人信息
 */
- (BOOL)findLocationUserPersonalInformation;

/**
 * @abstract 获取参数表
 */
- (DBParameter *)getParameter;
/**
 * @abstract 获取绑定客房数据
 */
- (DBBindCustom *)getCustomerBingRoom;

/**
 * @abstract 获取指定任务信息
 */
- (DBCallTask *)getCallTaskByTaskCode:(NSString *)taskCode;

@end
