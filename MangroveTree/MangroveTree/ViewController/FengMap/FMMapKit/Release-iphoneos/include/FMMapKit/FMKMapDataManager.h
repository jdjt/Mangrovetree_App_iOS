//
//  FMKMapDataManager.h
//  FMMapKit
//
//  Created by FengMap on 15/4/27.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

/**
 *  本部分用于sdk的数据管理，
    包括网络数据下载，本地数据缓存等
 */

#import <Foundation/Foundation.h>

@class FMKThemeDataManager;

/**
 * fengmap的数据管理类
 */
@interface FMKMapDataManager : NSObject

/**
 *  获取数据管理器
 */
+ (instancetype)shareInstance;

/**
 * @brief 地图数据保存路径
 */
@property (nonatomic,copy) NSString* mapPath;

/**
 *  判断地图数据本地是否已存在
 *
 *  @param mapID 地图ID
 *
 *  @return Y/N
 */
- (BOOL)mapExistWithID:(NSString *)mapID;

/**
 *  保存新的地图数据（保存地图.fmap数据）
 *
 *  @param mapData 地图数据
 *  @param mapID   地图ID
 */
- (void)saveMapData:(NSData *)mapData ID:(NSString *)mapID;

/**
 *  获取mapID的地图文件路径
 *
 *  @param mapID 地图ID
 *
 *  @return 该ID数据文件所在路径
 */
- (NSString *)getMapDataPathWithID:(NSString *)mapID;

/**
 *  由地图数据路径获取mapID
 *
 *  @param dataPath 地图数据文件路径
 *
 *  @return 地图ID
 */
- (NSString *)getMapIDWithLocalPath:(NSString *)dataPath;

/**
 *  删除地图ID的数据
 *
 *  @param mapID 地图ID
 */
- (void)deleteLocalDataWithID:(NSString *)mapID;

/**
 * 删除所有地图数据
 */
- (void)deleteAllLocalData;

@end
