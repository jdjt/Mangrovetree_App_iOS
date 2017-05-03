//
//  SaveNavigationData.m
//  qqqqaaaa
//
//  Created by new on 2017/5/2.
//  Copyright © 2017年 com.nono. All rights reserved.
//

#import "SaveNavigationData.h"

@implementation SaveNavigationData

+(instancetype) shareInstance
{
    static SaveNavigationData* _instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    }) ;
    return _instance ;
}

-(NSMutableDictionary *)mapTestDic{

    if (_mapTestDic == nil) {
        _mapTestDic = [[NSMutableDictionary alloc]init];
        
    }
    return _mapTestDic;
}
+(void)saveNavigationData{
    
    NSMutableDictionary * dataDic = [SaveNavigationData shareInstance].mapTestDic;
    

    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [documentPath stringByAppendingString:@"/mapTest3.plist"];
    
    NSFileManager * fileManager =[NSFileManager defaultManager];
    
    
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    
    NSFileHandle * fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    [fileHandle seekToEndOfFile];
    
    NSString *newlineStr =@"\n";
    NSData *newlineData =[newlineStr dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:newlineData];
    NSData * data =  [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
    [fileHandle writeData:data];

    
    
    
    
  
    
  
}
@end
