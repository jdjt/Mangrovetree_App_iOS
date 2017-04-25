//
//  ChatViewController.h
//  MangroveTree
//
//  Created by liuchao on 2017/4/12.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController

// 网络请求
@property (nonatomic, strong) NSURLSessionTask *seesionSengTask;
@property (nonatomic, strong) NSURLSessionTask *cancelTaskSession;
@property (nonatomic, strong) NSURLSessionTask *cancelListSession;
@property (nonatomic, strong) NSURLSessionTask *taskDeatilSession;


@end
