//
//  JHNewChangePhoneVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/18.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHNewChangePhoneVC.h"
 
#import "XHCodeTF.h"
#import "SecurityCode.h"
#import "JHCodeVC.h"

@interface JHNewChangePhoneVC ()<UITextFieldDelegate>
{
    UILabel *topL;
    UILabel *leftL;
    XHCodeTF *phoneF;
    UIView *lineView;
    UIButton * sureBtn;
    SecurityCode *_control;
    
}

@end

@implementation JHNewChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更换手机号";
     _control = [[SecurityCode alloc] init];
    [self creatUI];
}
-(void)creatUI{
    
    topL = [[UILabel alloc]init];
    [self.view addSubview:topL];
    [topL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 17+NAVI_HEIGHT;
        make.left.offset = 20;
        make.width.offset = 200;
        make.height.offset = 50;
    }];
    topL.textColor = TEXT_COLOR;
    topL.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    topL.text = @"输入新的手机号";

    leftL = [[UILabel alloc]init];
    [self.view addSubview:leftL];
    [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topL.mas_bottom).offset = 0;
        make.left.offset = 20;
        make.width.offset = 50;
        make.height.offset = 50;
    }];
     leftL.font = FONT(16);
     leftL.textColor = TEXT_COLOR;
     leftL.text = @"手机号";
    
    phoneF = [[XHCodeTF alloc]init];
    [self.view addSubview:phoneF];
    [phoneF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftL.mas_top);
        make.left.equalTo(leftL.mas_right).offset = 20;
        make.width.offset = 200;
        make.height.offset = 50;
    }];
    phoneF.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    phoneF.textColor = TEXT_COLOR;
    phoneF.delegate = self;
    phoneF.keyboardType = UIKeyboardTypeNumberPad;
    phoneF.placeholder = [NSString stringWithFormat:@"   请输入%d位数的手机号",PhoneLength];
    [phoneF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    lineView = [[UIView alloc]init];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftL.mas_bottom);
        make.left.equalTo(leftL.mas_left);
        make.right.offset = -20;
        make.height.offset = 1;
    }];
    lineView.backgroundColor = HEX(@"e5e5e5", 1);
    
    
    sureBtn = [[UIButton alloc]init];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftL.mas_bottom).offset = 30;
        make.left.offset = 12;
        make.right.offset = -12;
        make.height.offset = 44;
    }];
//    sureBtn.backgroundColor = HEX(@"cccccc", 1);
    sureBtn.layer.cornerRadius = 2;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"获取验证码" forState:0];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sureBtn setBackgroundColor:HEX(@"cccccc", 1) forState:0];
    [sureBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
 
}

-(void)textDidChange:(UITextField *)textField{
    if (textField.text.length == PhoneLength) {
        
        [sureBtn setBackgroundColor:THEME_COLOR forState:0];
        sureBtn.userInteractionEnabled= YES;
    }else{
        [sureBtn setBackgroundColor:HEX(@"cccccc", 1) forState:0];
        sureBtn.userInteractionEnabled= NO;
    }
    
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length == 0){
        return YES;
    }
    if (textField.text.length == PhoneLength) {
        return NO;
    }else{
        
        return YES;
    }
    
    
    
}
#pragma mark - 获取验证码
-(void)getCode{
    [[NSUserDefaults standardUserDefaults] setObject:phoneF.text forKey:@"SECURITY_MOBILE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *dic = @{@"mobile":phoneF.text};
    [HttpTool postWithAPI:@"magic/sendsms" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        
        if ([json[@"error"] isEqualToString:@"0"]) {
            
            if ([json[@"data"][@"sms_code"] isEqualToString:@"1"]) {
                //获取图形验证码
                [HttpTool postWithAPI:@"magic/verify" withParams:dic success:^(id json) {
                    
                    if(json){
                        [_control showSecurityViewWithBlock:^(NSString *result, NSString *code) {
                            [_control removeFromSuperview];
                            if ([result isEqualToString:NSLocalizedString(@"正确", nil)]) {
                                [self pushtoNext];
                                
                            }
                        }];
                        [_control refesh:json];
                        
                    }else{
                        [self showToastAlertMessageWithTitle:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                    }
                } failure:^(NSError *error) {
                    [self showToastAlertMessageWithTitle:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                    NSLog(@"%@",error.localizedDescription);
                }];
            }else{
         [self pushtoNext];
                
            }
            //获取图形验证码
        }else{
            [self showToastAlertMessageWithTitle:json[@"message"]];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
    }];
    
    
    
    
}

-(void)pushtoNext{
    
    JHCodeVC *vc =[[JHCodeVC alloc]init];
    vc.fromVC = @"JHNewChangePhoneVC";
    vc.phoneS = phoneF.text;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
@end
