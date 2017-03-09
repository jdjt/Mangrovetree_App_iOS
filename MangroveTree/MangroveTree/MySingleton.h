/**
 Copyright (c) 2012 Mangrove. All rights reserved.
 Author:mars
 Date:2014-10-24
 Description: 封装了请求服务器的url
 */

#import <Foundation/Foundation.h>

@interface MySingleton : NSObject

+ (MySingleton *)sharedSingleton;

/**
 *  @params  severIndex  当前选中的服务器地址
 *  @params  type        接口类型，新旧接口区分
 */
- (NSString *)currentServiceAddress:(NSInteger)severIndex byInterFaceType:(BOOL)type;


@property (nonatomic,strong) NSString *sessionId;

@property (nonatomic,readonly) NSString *baseInterfaceUrl;//接口地址根路径

@property (nonatomic,readonly) NSString *testUrl;   //测试接口地址根路径
@property (nonatomic,readonly) NSString *interTestUrl;   //测试接口地址根路径

@property (nonatomic,readonly) NSString* weixinInterfaceUrl;//微信接口根路径

@property (nonatomic,retain) NSString *svCode;

@property (nonatomic,retain) NSString *svItemCode;

@property (nonatomic,retain) NSString *picKind;

@property (nonatomic,retain) NSString *roomCode;

@property (nonatomic,retain) NSString *roomTypeCode;

@property (nonatomic,retain) NSString *floorCode;

@property (nonatomic,retain) NSArray *timeArray;

@property (nonatomic,retain) NSString *buildingCode;

@property (nonatomic,assign) NSInteger orderStatus;

@property (nonatomic,retain) NSNumber *itemId;

@property (nonatomic,retain) NSString *rateCode;

@property (nonatomic,retain) NSString *cardNo;

@end
