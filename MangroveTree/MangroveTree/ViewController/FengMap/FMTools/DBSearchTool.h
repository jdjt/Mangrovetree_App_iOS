//
//  DBSearchTool.h
//  mgmanager
//
//  Created by fengmap on 16/8/24.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QueryDBModel;

@interface DBSearchTool : NSObject

+ (instancetype)shareDBSearchTool;

/**
 *  根据typename查找
 *
 *  @param typeName typename
 *
 *  @return 查找结果 类型为QueryDBModel
 */
- (NSArray *)queryByTypeName:(NSString *)typeName;

/**
 *  根据subtypename查找
 *
 *  @param subTypeName subTypeName
 *
 *  @return 查找结果 类型为QueryDBModel
 */
- (NSArray *)queryBySubTypeName:(NSString *)subTypeName;
/**
 *  模糊查询
 *
 *  @param keyWord 关键字
 *
 *  @return 查找结果 类型为QueryDBModel
 */
- (NSArray *)queryByKeyWord:(NSString *)keyWord;

/**
 *  根据fid获取模型信息
 *
 *  @param fid fid
 *
 *  @return 模型信息
 */
- (QueryDBModel *)queryModelByFid:(NSString *)fid;
- (QueryDBModel *)queryModelByFid:(NSString *)fid andName:(NSString *)name;

/**
 *  创建或打开搜索历史纪录数据库
 *
 *  @return 创建结果
 */
- (BOOL)createOrOpenSearchHistoryRecordDB;

/**
 *  插入历史纪录结果
 *
 *  @param model model
 *
 *  @return 插入结果
 */
- (BOOL)insertHistoryRecord:(QueryDBModel *)model;

/**
 *  插入搜索历史
 *
 *  @param searchHistory 搜索历史
 *
 *  @return 插入结果
 */
- (BOOL)insertSearchHistory:(NSString *)searchHistory;

- (BOOL)containModel:(QueryDBModel *)model;
- (BOOL)containSearchRecord:(NSString *)searchHistory;
- (NSArray *)getAllSearchModel;
- (NSArray *)getAllSearchRecord;
/**
 *  删除历史纪录结果
 *
 *  @param model model
 *
 *  @return 删除结果
 */
- (BOOL)deleteHistoryRecord:(QueryDBModel *)model;

/**
 *  删除搜索历史
 *
 *  @param searchHistory 搜索历史
 *
 *  @return 删除结果
 */
- (BOOL)deleteSearchHistory:(NSString *)searchHistory;

/**
 *  删除所有历史纪录
 *
 *  @return 删除结果
 */
- (BOOL)deleteAllHistory;

@end
