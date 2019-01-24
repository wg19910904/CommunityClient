//
//  JHAdvVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/13.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHAdvVC.h"

@interface JHAdvVC ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}

@end

@implementation JHAdvVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.advModel.title;
    self.view.backgroundColor = BACK_COLOR;
    [self createWebView];
}
- (void)createWebView
{
    _webView = [[UIWebView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT)];
    [self.view addSubview:_webView];
    _webView.opaque = NO;
    _webView.backgroundColor = BACK_COLOR;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.advModel.link]]];
}
@end
