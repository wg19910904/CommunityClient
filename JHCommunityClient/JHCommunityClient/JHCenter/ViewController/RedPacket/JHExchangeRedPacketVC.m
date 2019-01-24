//
//  JHExchangeRedPacketVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//兑换红包

#import "JHExchangeRedPacketVC.h"
 
#import "NSObject+CGSize.h"
@interface JHExchangeRedPacketVC ()<UITextFieldDelegate>
{
    UITextField *_code;//兑换码
}
@end

@implementation JHExchangeRedPacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"兑换", nil);
    self.view.backgroundColor = BACK_COLOR;
    [self createUI];
    
}
#pragma mark====搭建UI界面=======
- (void)createUI
{
    UIView *backView = [[UIView alloc] initWithFrame:FRAME(10, (NAVI_HEIGHT+10), WIDTH - 20, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 4.0f;
    backView.layer.borderWidth = 0.3f;
    backView.layer.borderColor = HEX(@"999999", 0.3f).CGColor;
    [self.view addSubview:backView];
    _code = [[UITextField alloc] initWithFrame:FRAME(5, 0, WIDTH - 10, 40)];
    _code.font = FONT(14);
    _code.placeholder = NSLocalizedString(@"请输入兑换码", nil);
    _code.delegate = self;
    [backView addSubview: _code];
    UIButton *exchangeBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeBnt.frame = FRAME(10, 180  , WIDTH - 20, 35);
    [exchangeBnt setTitle:NSLocalizedString(@"兑换", nil) forState:UIControlStateNormal];
    [exchangeBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exchangeBnt.layer.cornerRadius = 4.0f;
    exchangeBnt.clipsToBounds = YES;
    exchangeBnt.titleLabel.font = FONT(14);
    [exchangeBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [exchangeBnt setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
    [exchangeBnt addTarget:self action:@selector(exchangeBnt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeBnt];
    UILabel *describeLabel = [[UILabel alloc] init];
    describeLabel.numberOfLines = 0;
    describeLabel.font = FONT(12);
    describeLabel.text = NSLocalizedString(@"*输入正确的兑换码可获得红包,在支付结算中使用红包获得优惠", nil);
    CGSize size = [self currentSizeWithString:describeLabel.text font:FONT(12) withWidth:20];
    describeLabel.frame = FRAME(10, 119, size.width, size.height);
    describeLabel.textColor = HEX(@"999999", 1.0f);
    [self.view addSubview:describeLabel];
    
    
}
#pragma mark======退出键盘===========
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touch_BackView
{
    [self.view endEditing:YES];
}
#pragma mark======兑换按钮点击事件===================
- (void)exchangeBnt
{
    NSLog(@"兑换啦");
    if(_code.text.length  == 0)
    {
        [self showAlertView:NSLocalizedString(@"请输入兑换码", nil)];
    }
    else
    {
        NSDictionary *dic = @{@"sn":_code.text};
        [HttpTool postWithAPI:@"client/member/hongbao/exchange" withParams:dic success:^(id json) {
            if([json[@"error"] isEqualToString:@"0"])
            {
                [self showAlertView:NSLocalizedString(@"红包兑换成功", nil)];
            }
            else
            {
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"红包兑换失败,原因:%@", nil),json[@"message"]]];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertView:error.localizedDescription];
        }];
        
    }
}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([title isEqualToString:NSLocalizedString(@"红包兑换成功", nil)]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
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
