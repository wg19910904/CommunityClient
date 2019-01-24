//
//  JHTuanGouProductDetailVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTuanGouProductPhotoDetailVC.h"
#import "JHTuanGouOrderVC.h"
@interface JHTuanGouProductPhotoDetailVC ()<UIWebViewDelegate>
@property(nonatomic, strong)UIWebView *mainWebView;
@end

@implementation JHTuanGouProductPhotoDetailVC
{
    UILabel *priceLabel;
    UILabel *storeLabel;
    UIButton *orderBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"团购详情", nil);
    //添加webView
    [self createWebView];
}
#pragma mark - 创建webView
- (void)createWebView
{
   
    self.mainWebView = [[UIWebView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT-50)];
    _mainWebView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_dataModel.tuwen_url]];
    [_mainWebView loadRequest:request];
    [self.view addSubview:_mainWebView];
     SHOW_HUD
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    HIDE_HUD
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    HIDE_HUD
    NSLog(@"webView加载完成");
    //添加底部view
    [self createBottomView];
}
#pragma mark - 添加底部view
- (void)createBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:FRAME(0, HEIGHT - 50, WIDTH, 50)];
    //添加子视图
    priceLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 200, 50)];
    priceLabel.font = FONT(30);
    NSMutableAttributedString *strng1 = [[NSMutableAttributedString alloc] initWithString:[@"¥" stringByAppendingString:_dataModel.price]];
    [strng1 addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 1)];
    priceLabel.attributedText = strng1;
    priceLabel.textColor = [UIColor colorWithRed:235/255.0 green:97/255.0 blue:0/255.0 alpha:1.0];
    
    orderBtn  = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 110, 5, 100, 40)];
    [orderBtn setTitle:NSLocalizedString(@"立即抢购", nil) forState:UIControlStateNormal];
    orderBtn.titleLabel.font = FONT(17);
    [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderBtn setBackgroundColor:[UIColor colorWithRed:235/255.0 green:97/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [orderBtn setBackgroundColor:[UIColor colorWithRed:235/255.0 green:97/255.0 blue:0/255.0 alpha:0.8] forState:UIControlStateHighlighted];
    orderBtn.layer.cornerRadius = 3;
    orderBtn.layer.masksToBounds = YES;
    [orderBtn addTarget:self action:@selector(clickOrderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    //添加上边线
    UIView *lineView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [bottomView addSubview:lineView];
    
    [bottomView addSubview:priceLabel];
    [bottomView addSubview:orderBtn];
    [self.view addSubview:bottomView];
}
#pragma mark - 点击下单按钮
- (void)clickOrderBtn:(UIButton *)sender
{
    JHTuanGouOrderVC *vc = [[JHTuanGouOrderVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.cellModel = _dataModel;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
