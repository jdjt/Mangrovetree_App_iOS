//
//  ChatViewController.m
//  MangroveTree
//
//  Created by liuchao on 2017/4/12.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatInputBar.h"
#import "ChatCell.h"
#import "PureLayout.h"
#import "ChatHeadView.h"
#import "NSString+Addtions.h"
#import "FrameViewController.h"
#import "ChatViewController+NetWork.h"

#define kSizeHead CGSizeMake(kScreenWidth, 74)

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,SendMsgDelegate,MTRequestNetWorkDelegate>

@property (nonatomic, strong) UITableView *chatTabelView;
@property (nonatomic, strong) ChatInputBar *chatInputView;
@property (nonatomic, strong) ChatHeadView *headView;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UIBarButtonItem *cancelBarItem;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headView];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:74];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    [self.headView autoSetDimensionsToSize:kSizeHead];
    
    // add tableView
    [self.view addSubview:self.chatTabelView];
    self.chatTabelView.backgroundColor = [UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1];
    [self.chatTabelView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headView withOffset:0];
    [self.chatTabelView autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
#warning test
    self.textView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.textView];
    self.textView.backgroundColor = [UIColor orangeColor];
//    self.textView.backgroundColor = [UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1];
    [self.textView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headView withOffset:0];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.textView autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    // add inputView
    self.textView.hidden = YES;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.textView.frame.size.height-2, kScreenWidth, 2)];
    bottomView.backgroundColor = [UIColor redColor];
    [self.textView addSubview:bottomView];
    [bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [bottomView autoSetDimensionsToSize:CGSizeMake(kScreenWidth, 1)];
    
    [self.view addSubview:self.chatInputView];
    [self.chatInputView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.chatTabelView];
    [self.chatInputView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.chatInputView autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    self.chatInputView.delegate = self;
    
    self.navigationItem.rightBarButtonItem = self.cancelBarItem;
    self.title = @"呼叫服务";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MTRequestNetwork defaultManager] registerDelegate:self];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[MTRequestNetwork defaultManager] removeDelegate:self];
}

#pragma mark - Getter Method

- (UITableView *)chatTabelView
{
    if (!_chatTabelView)
    {
        _chatTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
        _chatTabelView.delegate = self;
        _chatTabelView.dataSource = self;
        _chatTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTabelView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
    }
    return _chatTabelView;
}

- (ChatInputBar *)chatInputView
{
    if (!_chatInputView)
    {
        _chatInputView = [[ChatInputBar alloc] init];
        _chatInputView.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return _chatInputView;
}
- (ChatHeadView *)headView
{
    if (!_headView)
    {
        _headView = [[ChatHeadView alloc] init];
        _chatInputView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headView;
}
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (UIBarButtonItem *)cancelBarItem
{
    if (!_cancelBarItem)
    {
        _cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消任务" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTaskAction:)];
    }
    return _cancelBarItem;
}
#pragma mark - UITableView  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count > 0)
    {
        NSDictionary *dic = self.dataSource[0];
        CGFloat height = [NSString heightFromString:dic[@"text"] withFont:[UIFont systemFontOfSize:18.0f]  constraintToWidth:kScreenWidth-8*2];
        return height +64;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (!cell)
    {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatCell"];
        cell.backgroundColor = [UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1];
        if (self.dataSource.count>0) cell.model = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)sendMsgByChatBarView:(NSString *)inputText
{
    if (self.dataSource.count > 0)
    {
        return;
    }
    if (inputText != nil && ![inputText isEqualToString:@""])
    {
        NSDictionary *dic = @{@"text":@"您好，我的房间需要一杯饮料，请问你们都有什么类型的饮料，请给我列出一个清单，供我选择",@"are":@"叶林酒店",@"time":@"2017-05-24 05:24:21"};
        [self.dataSource addObject:dic];
        [self.chatTabelView reloadData];
        self.headView.textStatus = TextStatus_waiting;
//        self.chatTabelView.hidden = YES;
//        self.textView.hidden = NO;
//        self.chatInputView.hidden = YES;
//        [self.chatInputView inPutViewresignFirstResponder];
        [self sengMsgToSerive];
    }
}

- (void)startRequest:(NSURLSessionTask *)task
{
    
}
- (void)pushResponseResultsSucceed:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg andData:(NSMutableArray *)datas
{
    if (task == self.seesionSengTask)
    {
        
    }else if (task == self.cancelTaskSession)
    {
        
    }else if (task == self.cancelListSession)
    {
    }else if (task == self.taskDeatilSession)
    {
        
    }
}
- (void)pushResponseResultsFailing:(NSURLSessionTask *)task responseCode:(NSString *)code withMessage:(NSString *)msg
{
    if (task == self.seesionSengTask)
    {
        
    }else if (task == self.cancelTaskSession)
    {
        
    }else if (task == self.cancelListSession)
    {
    }else if (task == self.taskDeatilSession)
    {
        
    }
}

- (void)dealloc
{
    [[MTRequestNetwork defaultManager] cancleAllRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
