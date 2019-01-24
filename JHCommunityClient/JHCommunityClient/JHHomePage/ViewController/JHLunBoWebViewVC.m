//
//  JHLunBoWebViewVC.m
//  Lunch
//
//  Created by xixixi on 16/2/1.
//  Copyright © 2016年 jianghu. All rights reserved.
//

#import "JHLunBoWebViewVC.h"

@implementation JHLunBoWebViewVC
{
    UIWebView *_webVeiw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = _titleString;
    //添加左按钮
    [self createLeftBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建webView
    [self createWebView];    
}

#pragma mark - 创建左边按钮
- (void)createLeftBtn
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 9, 15)];
    [leftBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

#pragma mark - 创建webVeiw
- (void)createWebView
{

    _webVeiw = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    _webVeiw.delegate = self;
    [self.view addSubview:_webVeiw];
    SHOW_HUD
    [_webVeiw loadRequest:request];
    [self performSelector:@selector(hidehud) withObject:nil afterDelay:3];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    HIDE_HUD
}

- (void)hidehud
{
    HIDE_HUD
}
#pragma mark - 点击返回按钮
- (void)clickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [UserDefaults removeObjectForKey:@"lunboPic_1"];
}
@end
