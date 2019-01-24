//
//  JHNegotiateVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//  用户协议

#import "JHNegotiateVC.h"
 
#import "MBProgressHUD.h"
@interface JHNegotiateVC ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation JHNegotiateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"用户协议", nil);
    _webView = [[UIWebView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [self requestData];

}
- (void)requestData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/app/protocol" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:json[@"data"][@"url"]]]];
            HIDE_HUD
        }
        else
        {
            HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"数据加载失败,原因:%@", nil),json[@"message"]]];
        }
        
        
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
