//
//  BaseWebViewController.m
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/3/29.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController () <UIWebViewDelegate>

@property (nonatomic, copy) NSString * webUrl;

@end

@implementation BaseWebViewController

- (instancetype)initWithUrl:(NSString *)url
{
    if (self == [super init])
    {
        _webUrl = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addWebView];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NotiChangeStatusBar object:@"0"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn_white"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - webView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MyAlertView showAlert:@"网络加载失败，请退出页面重新尝试"];
}

- (void)addWebView
{
    UIWebView * webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
    [self.view addSubview:webView];
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
