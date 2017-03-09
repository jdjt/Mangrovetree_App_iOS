//
//  MyAlertView.h
//  Safety
//
//  Created by shaoxiang on 14-6-26.
//  Copyright (c) 2014年 shaoxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRAlertView.h"

@interface MyAlertView : NSObject<UIAlertViewDelegate>
+(void)showDialog:(NSString*)msg;
+(void)showAlert:(NSString*)_warning;
@end
