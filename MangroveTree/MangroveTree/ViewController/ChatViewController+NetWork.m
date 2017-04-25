//
//  ChatViewController+NetWork.m
//  MangroveTree
//
//  Created by liuchao on 2017/4/25.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "ChatViewController+NetWork.h"

@implementation ChatViewController (NetWork)

#pragma mark - NetWorking

- (void)cancelTask:(NSString *)causeNum
{
    
    NSDictionary *dic = @{@"customerId":self.customBind.customerId,
                          @"taskCode":self.currentTask.taskCode,
                          @"causeCode":causeNum};
    self.cancelTaskSession = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                         webURL:URL_CANCEL_TASK
                                                                         params:dic
                                                                     withByUser:YES andOldInterfaces:YES];
}

- (void)sengMsgToSerive:(NSString *)message
{
    NSDictionary *dic = @{@"customerId":self.customBind.customerId,
                          @"taskContent":message,
                          @"mapInfo":@{@"hotelCode":@"2",
                                       @"floorNo":@"11",
                                       @"mapNo":@"222",
                                       @"positionX":@"111",
                                       @"positionY":@"22",
                                       @"positionZ":@"333"}};
    self.seesionSengTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                       webURL:URL_SENG_TASK
                                                                       params:dic
                                                                   withByUser:YES andOldInterfaces:YES];
}

- (void)cancelDesicListWithTastStatus:(NSString *)type
{
    NSDictionary *dic = @{@"cancelType":type};
    self.cancelListSession = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                         webURL:URL_CANCEL_LIST
                                                                         params:dic
                                                                     withByUser:YES andOldInterfaces:YES];
    
}

- (void)getTaskDetailByTaskCode:(NSString *)taskCode
{
    NSDictionary *dic = @{@"taskCode":taskCode};
    self.taskDeatilSession = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                         webURL:URL_GETTASK_TASKCODE
                                                                         params:dic
                                                                     withByUser:YES andOldInterfaces:YES];
    
}

- (void)comfirmTask:(NSString *)comfirm andTaskCode:(NSString *)taskCode
{
    NSDictionary *dic = @{@"taskCode":taskCode,
                          @"confirmStatus":comfirm};
    self.comfirmTaskSession = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                         webURL:URL_COMFIRMTASK
                                                                         params:dic
                                                                     withByUser:YES andOldInterfaces:YES];
}

@end
