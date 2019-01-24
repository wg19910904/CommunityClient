//
//  JHHouseKeepingOrderDetailVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/19.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHMaintainOrderDetailVC.h"
#import "NSObject+CGSize.h"
 
#import "UIImageView+NetStatus.h"
#define imageHeight WIDTH/1.3
@interface JHMaintainOrderDetailVC ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    UIImageView *_displayImg;
   // UIScrollView *_scrollView;
}
@end

@implementation JHMaintainOrderDetailVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = self.name;
    self.view.backgroundColor = BACK_COLOR;
    [self requestData];
    
}
#pragma mark======搭建UI界面=======
- (void)createUI{
    UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, - imageHeight - 60, WIDTH, imageHeight + 60)];
    backView.backgroundColor = [UIColor whiteColor];
    _displayImg = [[UIImageView alloc] initWithFrame:FRAME(0, 0, WIDTH, imageHeight)];
    _displayImg.contentMode = UIViewContentModeScaleAspectFill;
    _displayImg.clipsToBounds = YES;
    _displayImg.backgroundColor = [UIColor redColor];
    [backView addSubview:_displayImg];
    UILabel *priceLable = [[UILabel alloc] init];
    priceLable.textColor = HEX(@"f85357", 1.0f);
    priceLable.font = FONT(14);
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"%@起", nil),self.start];
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"/%@",self.start]];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:str];
    [attribute addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:range];
    CGSize size = [self currentSizeWithString:str font:FONT(14) withWidth:0];
    priceLable.frame = FRAME(10,imageHeight + 30, size.width, 10);
    priceLable.attributedText = attribute;
    [backView addSubview:priceLable];
    UIButton *submitBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBnt.frame = FRAME(WIDTH - 110,  imageHeight + 17.5, 100, 35);
    [submitBnt setTitle:NSLocalizedString(@"立即下单", nil) forState:UIControlStateNormal];
    [submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBnt.layer.cornerRadius = 4.0f;
    submitBnt.clipsToBounds = YES;
    submitBnt.titleLabel.font = FONT(14);
    [submitBnt setBackgroundColor:HEX(@"fc7400", 1.0f) forState:UIControlStateNormal];
    [submitBnt setBackgroundColor:HEX(@"ff5500", 1.0f) forState:UIControlStateHighlighted];
    [submitBnt addTarget:self action:@selector(submitOrderBnt) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:submitBnt];
    UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, imageHeight + 59.5, WIDTH, 0.5)];
    thread1.backgroundColor = LINE_COLOR;
    [backView addSubview:thread1];
    UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, imageHeight + 0.5, WIDTH, 0.5)];
    thread2.backgroundColor = LINE_COLOR;
    [backView addSubview:thread2];
    _webView = [[UIWebView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT)];
    _webView.delegate = self;
    _webView.backgroundColor = BACK_COLOR;
    _webView.opaque = NO;
    _webView.scrollView.contentInset = UIEdgeInsetsMake(imageHeight + 60, 0, 0, 0);
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [_webView.scrollView addSubview:backView];
    [self.view addSubview:_webView];
}

- (void)requestData{
    SHOW_HUD
    NSDictionary *dic = @{@"cate_id":self.cate_id};
    [HttpTool postWithAPI:@"client/weixiu/detail" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            [self createUI];
            NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:json[@"data"][@"photo"]]];
            [_displayImg sd_image:url plimage:IMAGE(@"jfbanner")];
            [_webView loadHTMLString:json[@"data"][@"info"] baseURL:nil] ;
            HIDE_HUD
        }
        else
        {
            HIDE_HUD
            [self showAlertView:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"数据加载失败,原因:", nil),json[@"message"]]];
        }
        
        
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
}

#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
#pragma mark======提交订单按钮点击事件======
- (void)submitOrderBnt{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
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
