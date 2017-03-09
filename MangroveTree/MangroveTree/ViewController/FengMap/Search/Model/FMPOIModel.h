//
//  FMPOIModel.h
//  mgmanager
//
//  Created by fengmap on 16/7/9.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMPOIModel : NSObject

@property (nonatomic, copy) NSString *mapname;
@property (nonatomic, copy) NSString *mapid;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *grumid;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)fmPOIModelWithDict:(NSDictionary *)dict;
@end
