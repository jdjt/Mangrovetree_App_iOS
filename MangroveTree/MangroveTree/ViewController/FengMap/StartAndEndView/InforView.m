//
//  inforView.m
//  MangroveTree
//
//  Created by liuchao on 2017/3/13.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "InforView.h"

@interface InforView ()<MTRequestNetWorkDelegate>

@property (nonatomic, assign) BOOL hideView;
@property (nonatomic, strong) NSURLSessionTask *requesNetWork;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *text;

@end

@implementation InforView

+ (instancetype)inforView
{
    InforView * view = [[NSBundle mainBundle] loadNibNamed:@"InforView" owner:nil  options:nil][0];
    view.alpha = 0.0f;
    view.hideView = NO;
    [[MTRequestNetwork defaultManager] registerDelegate:view];
    return view;
}

- (void)hide
{
    __weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.4f animations:^{
        wSelf.alpha = 0.0f;
        wSelf.hideView = NO;
    }];
}

- (void)show
{
    self.alpha = 0.9f;
    __weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.4f animations:^{
        CGRect rect = self.frame;
        wSelf.frame = CGRectMake(0, kScreenHeight-120-49 -88, kScreenWidth, rect.size.height);
        wSelf.hideView = NO;
    }];
}

- (IBAction)tapViewAction:(id)sender
{
    self.hideView = !self.hideView;
    if (_hideBlock)
        _hideBlock(self.hideView);
}
- (void)requsrtActivityInforByActivityCode:(NSString *)activityCode
{
    //获取详细列表
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithCapacity:2];
    params = [NSMutableDictionary dictionaryWithDictionary:@{@"id":[Util getUUID],@"send":@{@"code":activityCode}}];
    self.requesNetWork = [[MTRequestNetwork defaultManager] POSTWithTopHead:@REQUEST_HEAD_NORMAL
                                                                          webURL:URL_ACTIVITY_DETAIL
                                                                          params:params
                                                                      withByUser:YES andOldInterfaces:NO];
}

- (void)startRequest:(NSURLSessionTask *)task
{
    
}

- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    InforModel *model = datas[0];
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage new]];
    self.name.text = model.name;
    self.text.text = model.abstracts;
}

- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    
}
- (void)dealloc
{
    [[MTRequestNetwork defaultManager] removeDelegate:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
