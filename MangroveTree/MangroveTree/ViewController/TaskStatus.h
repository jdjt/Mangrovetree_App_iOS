//
//  TaskStatus.h
//  mgmanager
//
//  Created by Sun Peng on 15/12/12.
//  Copyright © 2015年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STATUS_WAITING          0
#define STATUS_WAITING_EXPIRED  1
#define STATUS_ACCEPT           2
#define STATUS_ACCEPT_EXPIRED   3
#define STATUS_FINISH           4
#define STATUS_FINISH_EXPIRED   5

@interface TaskStatus : NSObject
//
//@property (retain, nonatomic) TaskStatus* globelStatus;

- (NSInteger)statusValue;

- (NSString*)statusName;

- (NSString*)cancelButtonText;

- (void)timeExpired;

- (void)waiterChanged;

- (NSInteger)isOverTask;

@end
