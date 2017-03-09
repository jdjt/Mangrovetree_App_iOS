//
//  FMDHCPNetService.h
//  FMMapKit
//
//  Created by fengmap on 16/11/10.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDHCPNetService : NSObject

+ (instancetype)shareDHCPNetService;

- (void)localMacAddress:(void(^)(NSString * macAddr))macAddress;

- (NSString *)localMacAddressCache;

- (NSString *)getMacAddress;
@end
