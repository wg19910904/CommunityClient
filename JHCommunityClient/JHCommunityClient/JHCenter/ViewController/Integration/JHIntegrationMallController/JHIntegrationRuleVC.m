//
//  JHIntegrationRuleVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHIntegrationRuleVC.h"
 
#import "MBProgressHUD.h"
@interface JHIntegrationRuleVC ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation JHIntegrationRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = NSLocalizedString(@"积分规则", nil);
    [self createWebView];
    [self requestData];
}
#pragma mark====初始化webView=========
- (void)createWebView
{
    _webView = [[UIWebView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT)];
    _webView.delegate = self;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_webView];
}
#pragma mark=====请求网络数据======
- (void)requestData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/member/jifen/rule" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:json[@"data"]]]];
            HIDE_HUD
        }else{
            HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"数据加载失败,原因:%@", nil),json[@"message"]]];
        }
       
        
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
@end
