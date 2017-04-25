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

- (void)cancelTaskAction:(UIBarButtonItem *)bar
{
    
    NSDictionary *dic = @{@"customerId":@"1008",@"taskCode":@"123456",@"causeCode":@"108"};
    self.cancelTaskSession = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                         webURL:URL_CANCEL_TASK params:dic
                                                                     withByUser:YES andOldInterfaces:YES];
}
- (void)sengMsgToSerive
{
    NSDictionary *dic = @{@"customerId":@"1008",
                          @"taskContent":@"您好，我的房间需要一杯饮料，请问你们都有什么类型的饮料，请给我列出一个清单，供我选择",
                          @"mapInfo":
                              @{@"hotelCode":@"2",@"floorNo":@"11",@"mapNo":@"222",@"posionX":@"111",@"positionY":@"22",@"postionZ":@"333"}};
    self.seesionSengTask = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                       webURL:URL_SENG_TASK params:dic
                                                                   withByUser:YES andOldInterfaces:YES];
}
- (void)cancelDesicListWithTastStatus:(NSString *)type
{
    NSDictionary *dic = @{@"cancelType":type};
    self.cancelListSession = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                         webURL:URL_CANCEL_LIST params:dic
                                                                     withByUser:YES andOldInterfaces:YES];
    
}
- (void)getTaskDetailByTaskCode:(NSString *)taskCode
{
    NSDictionary *dic = @{@"taskCode":@"1008"};
    self.taskDeatilSession = [[MTRequestNetwork defaultManager] POSTWithTopHead:
                              @REQUEST_HEAD_NORMAL
                                                                         webURL:URL_GETTASK_TASKCODE
                                                                         params:dic
                                                                     withByUser:YES andOldInterfaces:YES];
    
}


@end
