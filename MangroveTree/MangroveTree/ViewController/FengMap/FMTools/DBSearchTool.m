//
//  DBSearchTool.m
//  mgmanager
//
//  Created by fengmap on 16/8/24.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "DBSearchTool.h"
#import "FMDB.h"
#import "QueryDBModel.h"

NSString * const kHistoryRecordDBName = @"HistoryRecordDB.sqlite";
NSString * const kHistoryRecordTableName = @"historyRecord";

static DBSearchTool * mDbSearcTool = nil;

@interface DBSearchTool()
@property (nonatomic, copy) NSString * dbPath;
@property (nonatomic, strong) FMDatabase * db;
@property (nonatomic, strong) FMDatabase * historyRecordDB;
@end

@implementation DBSearchTool

+ (instancetype)shareDBSearchTool
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		mDbSearcTool = [[DBSearchTool allocWithZone:NULL] init];
		mDbSearcTool.dbPath = [[NSBundle mainBundle] pathForResource:@"mangrove.sqlite" ofType:nil];
		mDbSearcTool.db = [FMDatabase databaseWithPath:mDbSearcTool.dbPath];
	});
	return mDbSearcTool;
}

+ (instancetype)alloc
{
	return [DBSearchTool shareDBSearchTool];
}
//根据typename查询
- (NSArray *)queryByTypeName:(NSString *)typeName
{
	NSMutableArray * result = [NSMutableArray array];
	if (![mDbSearcTool.db open]) {
		NSLog(@"数据库打开失败");
	}
	else
	{
		NSLog(@"数据库打开成功");
	}
	NSString * sql = [NSString stringWithFormat:
					  @"SELECT rowid, * FROM 'stores'"];
	FMResultSet * rs = [mDbSearcTool.db executeQuery:sql];
	while ([rs next]) {
		NSString * typename = [rs stringForColumn:@"typename"];
		if (![typeName isEqualToString:typename]) {
			continue;
		}
		NSString * address = [rs stringForColumn:@"address"];
		NSString * fid = [rs stringForColumn:@"fid"];
		NSString * name = [rs stringForColumn:@"name"];
		NSString * ename = [rs stringForColumn:@"ename"];
		NSString * mid = [rs stringForColumn:@"mid"];
		double x = [rs doubleForColumn:@"x"];
		double y = [rs doubleForColumn:@"y"];
		int gid = [rs intForColumn:@"gid"];
		int ftype = [rs intForColumn:@"ftype"];
		float z = [rs doubleForColumn:@"z"];
		int type = [rs intForColumn:@"type"];
		int rowid = [rs intForColumn:@"id"];
		
		QueryDBModel * model = [[QueryDBModel alloc] init];
		model.typeName = typename;
		model.address = address;
		model.fid = fid;
		model.x = x;
		model.y = y;
		model.gid = gid;
		model.ftype = ftype;
		model.type = type;
		model.z = z;
		model.name = name;
		model.ename = ename;
		model.mid = mid;
		model.rowid = rowid;
		
		[result addObject:model];
	}
	[mDbSearcTool.db close];
	return result;
}

//模糊查询
- (NSArray *)queryByKeyWord:(NSString *)keyWord
{
	NSMutableArray * result = [NSMutableArray array];
	if (![mDbSearcTool.db open])
	{
		NSLog(@"数据库打开失败");
	}
	else
	{
		NSLog(@"数据库打开成功");
	}
	NSString * sql = [NSString stringWithFormat:
					  @"SELECT rowid, * FROM 'stores'"];
	FMResultSet * rs = [mDbSearcTool.db executeQuery:sql];
	while ([rs next]) {
		NSString * name = [rs stringForColumn:@"name"];
		if ([name rangeOfString:keyWord].location != NSNotFound || [name rangeOfString:keyWord.uppercaseString].location != NSNotFound || [name rangeOfString:keyWord.lowercaseString].location != NSNotFound)
		{
			NSString * address = [rs stringForColumn:@"address"];
			NSString * fid = [rs stringForColumn:@"fid"];
			NSString * typeName = [rs stringForColumn:@"typename"];
			NSString * ename = [rs stringForColumn:@"ename"];
			NSString * mid = [rs stringForColumn:@"mid"];
			double x = [rs doubleForColumn:@"x"];
			double y = [rs doubleForColumn:@"y"];
			int gid = [rs intForColumn:@"gid"];
			int ftype = [rs intForColumn:@"ftype"];
			float z = [rs doubleForColumn:@"z"];
			int type = [rs intForColumn:@"type"];
			int rowid = [rs intForColumn:@"rowid"];
			
			QueryDBModel * model = [[QueryDBModel alloc] init];
			model.typeName = typeName;
			model.address = address;
			model.fid = fid;
			model.x = x;
			model.y = y;
			model.gid = gid;
			model.ftype = ftype;
			model.type = type;
			model.z = z;
			model.name = name;
			model.ename = ename;
			model.mid = mid;
			model.rowid = rowid;
			[result addObject:model];
		}
	}
	[mDbSearcTool.db close];
	return result;
}

- (QueryDBModel *)queryModelByFid:(NSString *)fid
{
	if ([mDbSearcTool.db open]) {
		NSString * sql = [NSString stringWithFormat:
						  @"SELECT rowid, * FROM 'stores'"];
		FMResultSet * rs = [mDbSearcTool.db executeQuery:sql];
		while ([rs next]) {
			NSString * sqlFid = [rs stringForColumn:@"fid"];
			if (![sqlFid isEqualToString:fid]) {
				continue;
			}
			NSString * address = [rs stringForColumn:@"address"];
			NSString * fid = [rs stringForColumn:@"fid"];
			NSString * typeName = [rs stringForColumn:@"typename"];
			NSString * ename = [rs stringForColumn:@"ename"];
			NSString * mid = [rs stringForColumn:@"mid"];
			NSString * name = [rs stringForColumn:@"name"];
			double x = [rs doubleForColumn:@"x"];
			double y = [rs doubleForColumn:@"y"];
			int gid = [rs intForColumn:@"gid"];
			int ftype = [rs intForColumn:@"ftype"];
			float z = [rs doubleForColumn:@"z"];
			int type = [rs intForColumn:@"type"];
			int rowid = [rs intForColumn:@"rowid"];
			
			QueryDBModel * model = [[QueryDBModel alloc] init];
			model.typeName = typeName;
			model.address = address;
			model.fid = fid;
			model.x = x;
			model.y = y;
			model.gid = gid;
			model.ftype = ftype;
			model.type = type;
			model.z = z;
			model.fid = fid;
			model.ename = ename;
			model.mid = mid;
			model.rowid = rowid;
			model.name = name;
			
			[mDbSearcTool.db close];
			return model;
			
		}
	}
	return nil;
}

//创建历史纪录数据库
- (BOOL)createOrOpenSearchHistoryRecordDB
{
	NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	path=[path stringByAppendingPathComponent:kHistoryRecordDBName];
	mDbSearcTool.historyRecordDB = [FMDatabase databaseWithPath:path];
	//打开数据库，如果不存在则创建并且打开
	BOOL open = [mDbSearcTool.historyRecordDB open];
	if(open){
		NSLog(@"数据库打开成功");
	}
	else
	{
		NSLog(@"数据库打开失败");
	}
//	historyRecord是表名称
	 NSString *sql = @"CREATE TABLE if not exists historyRecord (id integer PRIMARY KEY autoincrement,mid QString,fid QString,gid int,ftype int,name QString,ename QString,type long,typename QString,x DECIMAL(10,5),y DECIMAL(10,5),z float,address QString, history QString)";
	if ([mDbSearcTool.historyRecordDB executeUpdate:sql]) {
		NSLog(@"历史纪录表单创建成功");
		[mDbSearcTool.historyRecordDB close];
		return YES;
	}
	else
	{
		NSLog(@"历史纪录表单创建失败");
		return NO;
	}
}

- (BOOL)insertHistoryRecord:(QueryDBModel *)model
{
	if ([mDbSearcTool.historyRecordDB open]) {
		NSString *insertSql = [NSString stringWithFormat:
							   @"INSERT INTO '%@' ('name', 'typename', 'mid','gid','address','fid','x','y','z','ftype','type','ename','id') VALUES ('%@', '%@', '%@','%d', '%@', '%@','%lf', '%lf', '%f','%d', '%@', '%@','%d')",
							   kHistoryRecordTableName, model.name, model.typeName, model.mid,model.gid,model.address,model.fid,model.x,model.y,model.z,model.ftype,model.typeName,model.ename,model.rowid];
		BOOL successInsert = [mDbSearcTool.historyRecordDB executeUpdate:insertSql];
		[mDbSearcTool.historyRecordDB close];
		return successInsert;
		
	}
	return NO;
}

- (BOOL)insertSearchHistory:(NSString *)searchHistory
{
	if ([mDbSearcTool.historyRecordDB open]) {
		NSString *insertSql= [NSString stringWithFormat:
							   @"INSERT INTO '%@' ('history') VALUES ('%@')",
							   kHistoryRecordTableName, searchHistory];
		BOOL successInsert = [mDbSearcTool.historyRecordDB executeUpdate:insertSql];
		[mDbSearcTool.historyRecordDB close];
		return successInsert;
	}
	return NO;

}

- (BOOL)containModel:(QueryDBModel *)model
{
	if ([mDbSearcTool.historyRecordDB open]) {
		NSString * sql = [NSString stringWithFormat:
						  @"SELECT rowid, * FROM '%@'",kHistoryRecordTableName];
		FMResultSet * rs = [mDbSearcTool.historyRecordDB executeQuery:sql];
		while ([rs next]) {
			NSString * fid = [rs stringForColumn:@"fid"];
			if ([fid isEqualToString:model.fid]) {
				[mDbSearcTool.historyRecordDB close];
				return YES;
			}
		}
		[mDbSearcTool.historyRecordDB close];
		return NO;
	}
	return NO;
}

- (BOOL)containSearchRecord:(NSString *)searchHistory
{
	if ([mDbSearcTool.historyRecordDB open]) {
		NSString * sql = [NSString stringWithFormat:
						  @"SELECT rowid, * FROM '%@'",kHistoryRecordTableName];
		FMResultSet * rs = [mDbSearcTool.historyRecordDB executeQuery:sql];
		while ([rs next]) {
			NSString * history = [rs stringForColumn:@"history"];
			if ([searchHistory isEqualToString:history]) {
				[mDbSearcTool.historyRecordDB close];
				return YES;
			}
		}
		[mDbSearcTool.historyRecordDB close];
		return NO;
	}
	return NO;
}

- (NSArray *)getAllSearchModel
{
	NSMutableArray * result = [NSMutableArray array];
	if ([mDbSearcTool.historyRecordDB open]) {
		NSString * sql = [NSString stringWithFormat:
						  @"SELECT rowid, * FROM '%@'",kHistoryRecordTableName];
		FMResultSet * rs = [mDbSearcTool.historyRecordDB executeQuery:sql];
		while ([rs next]) {
			NSString * name = [rs stringForColumn:@"name"];
			NSString * address = [rs stringForColumn:@"address"];
			NSString * fid = [rs stringForColumn:@"fid"];
			
			if (!fid) {
				continue;
			}
			
			NSString * typeName = [rs stringForColumn:@"typename"];
			NSString * ename = [rs stringForColumn:@"ename"];
			NSString * mid = [rs stringForColumn:@"mid"];
			double x = [rs doubleForColumn:@"x"];
			double y = [rs doubleForColumn:@"y"];
			int gid = [rs intForColumn:@"gid"];
			int ftype = [rs intForColumn:@"ftype"];
			float z = [rs doubleForColumn:@"z"];
			int type = [rs intForColumn:@"type"];
			int rowid = [rs intForColumn:@"rowid"];
			
			QueryDBModel * model = [[QueryDBModel alloc] init];
			model.typeName = typeName;
			model.address = address;
			model.fid = fid;
			model.x = x;
			model.y = y;
			model.gid = gid;
			model.ftype = ftype;
			model.type = type;
			model.z = z;
			model.name = name;
			model.ename = ename;
			model.mid = mid;
			model.rowid = rowid;
			[result addObject:model];
		}
		[mDbSearcTool.historyRecordDB close];
		return result;
	}
	return nil;
}

- (NSArray *)getAllSearchRecord
{
	NSMutableArray * result = [NSMutableArray array];
	if ([mDbSearcTool.historyRecordDB open]) {
		NSString * sql = [NSString stringWithFormat:
						  @"SELECT rowid, * FROM '%@'",kHistoryRecordTableName];
		FMResultSet * rs = [mDbSearcTool.historyRecordDB executeQuery:sql];
		while ([rs next]) {
			NSString * history = [rs stringForColumn:@"history"];
			if (history) {
				[result addObject:history];
			}
			
		}
		[mDbSearcTool.historyRecordDB close];
		return result;
	}
	return nil;

}

- (BOOL)deleteHistoryRecord:(QueryDBModel *)model
{
	if ([mDbSearcTool.historyRecordDB open]) {
		NSString *insertSql= [NSString stringWithFormat:
							  @"delete from '%@' where id='%d'",
							  kHistoryRecordTableName, model.rowid];
		BOOL successInsert = [mDbSearcTool.historyRecordDB executeUpdate:insertSql];
		[mDbSearcTool.historyRecordDB close];
		return successInsert;
	}
	return NO;
}

- (BOOL)deleteSearchHistory:(NSString *)searchHistory
{
	if ([mDbSearcTool.historyRecordDB open]) {
		NSString *insertSql= [NSString stringWithFormat:
							  @"delete from '%@' ('history') VALUES ('%@')",
							  kHistoryRecordTableName, searchHistory];
		BOOL successInsert = [mDbSearcTool.historyRecordDB executeUpdate:insertSql];
		[mDbSearcTool.historyRecordDB close];
		return successInsert;
	}
	return NO;
}

- (BOOL)deleteAllHistory
{
	if ([mDbSearcTool.historyRecordDB open]) {
		NSString * sql = [NSString stringWithFormat:@"DELETE FROM '%@'",kHistoryRecordTableName];
		BOOL success = [mDbSearcTool.historyRecordDB executeUpdate:sql];
		NSString * sql1 = [NSString stringWithFormat:@"UPDATE sqlite_sequence set seq=0 where history=%@",kHistoryRecordTableName];
		[mDbSearcTool.historyRecordDB executeUpdate:sql1];
		[mDbSearcTool.historyRecordDB close];
		return success;
	}
	return NO;
}

- (void)dealloc
{
	[mDbSearcTool.historyRecordDB close];
	[mDbSearcTool.db close];
}

@end
