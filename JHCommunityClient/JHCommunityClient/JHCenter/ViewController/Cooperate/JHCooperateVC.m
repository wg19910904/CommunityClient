//
//  JHCooperateVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/4.
//  Copyright © 2016年 JiangHu. All rights reserved.
//申请合作

#import "JHCooperateVC.h"
#import "JHLoginVC.h"
#define PAOTUI @"itms-apps://itunes.apple.com/cn/app/jiang-hu-wai-mai-pei-song/id1080931079?mt=8"
#define SHOP @"itms-apps://itunes.apple.com/cn/app/jiang-hu-wai-mai-pei-song/id1080931079?mt=8"
@interface JHCooperateVC ()<UIWebViewDelegate>
{
    UIView *_coverView;
    UIButton *_lastBnt;
    UIImageView *_img1;//图片
    UIButton *_nowBnt;//申请按钮
    UIImageView *_img2;
    UIWebView *webView;
}
@end

@implementation JHCooperateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"申请合作", nil);
    [self createUI];
    SHOW_HUD
}
#pragma mark==========搭建UI界面======
- (void)createUI
{
    webView = [[UIWebView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",KReplace_Url,@"about"]];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    webView.delegate = self;
    [self.view addSubview:webView];
//    UIView *backView = [[UIView alloc] initWithFrame:FRAME(0,(NAVI_HEIGHT+10), WIDTH, 30)];
//    backView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:backView];
//    for(int i = 0; i < 2; i ++)
//    {
//        UIButton *bnt = [UIButton buttonWithType:UIButtonTypeCustom];
//        bnt.frame = FRAME(i * WIDTH /2, 0, WIDTH /2, 30);
//        bnt.tag = i + 1;
//        [bnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [bnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];
//        if(i == 0)
//        {
//            [bnt setTitle:NSLocalizedString(@"申请跑腿小哥", nil) forState:UIControlStateNormal];
//           
//            bnt.selected = YES;
//            _lastBnt = bnt;
//        }
//        else
//        {
//            [bnt setTitle:NSLocalizedString(@"申请商家入驻", nil) forState:UIControlStateNormal];
//        }
//         bnt.titleLabel.font = FONT(14);
//        [bnt addTarget:self action:@selector(clickBnt:) forControlEvents:UIControlEventTouchUpInside];
//        [backView addSubview:bnt];
//    }
//    _coverView = [[UIView alloc] initWithFrame:FRAME(15, 29, (WIDTH - 30 * 2)/2, 1)];
//    _coverView.backgroundColor = THEME_COLOR;
//    [backView addSubview:_coverView];
//    _img1 = [[UIImageView alloc] initWithFrame:FRAME(40, 104, WIDTH - 80,( WIDTH  - 80)/ 1.3)];
//    _img1.image = IMAGE(@"shenqing");
//    [self.view addSubview:_img1];
//    _img2 = [[UIImageView alloc] initWithFrame:FRAME(20, 104 + (WIDTH  - 80)/ 1.3, WIDTH - 40, (WIDTH  - 40)/ 2)];
//    _img2.image = IMAGE(@"brother");
//    [self.view addSubview:_img2];
//    _nowBnt = [UIButton buttonWithType:UIButtonTypeCustom];
//    _nowBnt.frame = FRAME(10,HEIGHT - 50,WIDTH - 20, 40);
//    [_nowBnt setTitle:NSLocalizedString(@"立即申请", nil) forState:UIControlStateNormal];
//    [_nowBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _nowBnt.layer.cornerRadius = 4.0f;
//    _nowBnt.clipsToBounds = YES;
//    _nowBnt.titleLabel.font = FONT(14);
//    [_nowBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
//    [_nowBnt setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
//    [_nowBnt addTarget:self action:@selector(nowBnt:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_nowBnt];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    HIDE_HUD
    NSLog(@"%@",error.localizedDescription);
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    HIDE_HUD
}
#pragma mark===========立即申请,立即入住按钮的点击事件========
- (void)nowBnt:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"立即申请", nil)])
    {
        NSLog(@"小哥");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"成为跑腿小哥", nil) message:nil  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *deletAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //https://itunes.apple.com/cn/app/jiang-hu-wai-mai-pei-song/id1080931079?mt=8App成为跑腿小哥的链接地址
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PAOTUI]];
        }];
        [alertController addAction:deletAction];
        [alertController addAction:certainAction];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        NSLog(@"店家");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"成为商家掌柜", nil) message:nil  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *deletAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //https://itunes.apple.com/cn/app/jiang-hu-wai-mai-pei-song/id1080931079?mt=8App成为商家掌柜的链接地址
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SHOP]];
        }];
        [alertController addAction:deletAction];
        [alertController addAction:certainAction];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark======申请跑腿小哥，申请上家入驻==================
- (void)clickBnt:(UIButton *)sender
{
    if(_lastBnt != nil)
    {
        _lastBnt.selected = NO;
    }
    sender.selected = YES;
    _lastBnt = sender;
    _coverView.center = CGPointMake(sender.center.x, 29);
    
    if([sender.titleLabel.text isEqualToString:NSLocalizedString(@"申请跑腿小哥", nil)])
    {
        
        _img1.image = IMAGE(@"shenqing");
        _img2.image = IMAGE(@"brother");
        [_nowBnt setTitle:NSLocalizedString(@"立即申请", nil) forState:UIControlStateNormal];
    }
    else
    {
        _img1.image = IMAGE(@"shopshengqing");
        _img2.image = IMAGE(@"shop");
        [_nowBnt setTitle:NSLocalizedString(@"立即入驻", nil) forState:UIControlStateNormal];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"去登录", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JHLoginVC *loginVC = [[JHLoginVC alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }];
    [alertController addAction:loginAction];
    [self  presentViewController:alertController animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
