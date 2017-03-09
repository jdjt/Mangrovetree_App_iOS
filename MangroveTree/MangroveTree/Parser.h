//
//  Parser.h
//  MangroveTree
//
//  Created by 罗禹 on 2017/3/7.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject

@property (nonatomic, strong) NSMutableDictionary * params;

- (NSMutableArray*)parser:(NSString*)ident fromData:(NSData*)dict;

@end
