//
//  SaveNavigationData.h
//  qqqqaaaa
//
//  Created by new on 2017/5/2.
//  Copyright © 2017年 com.nono. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveNavigationData : NSObject

@property(nonatomic,strong)NSMutableDictionary * mapTestDic;
+(instancetype) shareInstance;
+(void)saveNavigationData;
@end
