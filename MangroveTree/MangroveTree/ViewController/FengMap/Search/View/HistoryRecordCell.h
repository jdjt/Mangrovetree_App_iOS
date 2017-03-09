//
//  HistoryRecordCell.h
//  mgmanager
//
//  Created by fengmap on 16/8/14.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoHereBlock)();

@interface HistoryRecordCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *positionLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *goHereButton;

@property (copy, nonatomic) GoHereBlock goHereBlock;
- (IBAction)goHereBtnClick:(id)sender;

@end
