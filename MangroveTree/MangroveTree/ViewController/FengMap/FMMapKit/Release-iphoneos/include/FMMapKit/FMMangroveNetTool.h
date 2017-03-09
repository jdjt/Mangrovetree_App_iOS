//
//  FMMangroveNetTool.h
//  FMMapKit
//
//  Created by fengmap on 16/10/31.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKGeometry.h"

@protocol FMMangroveNetToolDelegate <NSObject>

//开启获取位置的线程后 调用获取地图位置  实时更新回调  若要关闭 需手动调用关闭的方法
- (void)updatePosition:(FMKMapCoord)mapCoord macAddr:(NSString *)macAddr;

@end

@interface FMMangroveNetTool : NSObject
//上传位置信息的地址
@property (nonatomic, copy) NSString * uploadPositionUrl;
//上传位置信息的端口号
@property (nonatomic, assign) NSInteger port;

@property (nonatomic, weak) id<FMMangroveNetToolDelegate>delegate;

+ (instancetype)shareFMMangroveNetTool;

//开启上传线程
- (void)startUploadThread;

//开启获取位置线程
- (void)startGetPositionThread;

//装配上传的位置信息
- (void)setupUploadPositionInfo:(FMKMapCoord)mapCoord;

//MAC地址获取地图位置
- (void)getPositionByMacAddr:(NSString *)macAddr;

//停止特定设备的位置获取
- (void)closePositionRequestWithMac:(NSString *)macAddr;

//关闭位置请求
- (void)closeRequestPositionStream;

//暂停位置请求
- (void)pauseRequestPositionStream;

//重新开启位置请求
- (void)restartRequestPositionStream;

//停止上传位置
- (void)stopUploadPosition;

@end
