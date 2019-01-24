//
//  JHMobileMessageVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//手机快速登录

#import "JHMobileMessageVC.h"
#import "JHRegisterVC.h"
 
#import "MBProgressHUD.h"
#import "JHShareModel.h"
#import "JPUSHService.h"
#import "SecurityCode.h"
#import "XHCodeTF.h"
@interface JHMobileMessageVC ()<UITextFieldDelegate>

{
    XHCodeTF *_mobile;
    UITextField *_code;
    UIButton *_codeBnt;
    UIControl *_backView;
    NSTimer *_timer;
    int _num;
    SecurityCode *_control;
}
@end

@implementation JHMobileMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"快速登录", nil);
    _control = [[SecurityCode alloc] init];
    self.view.backgroundColor = BACK_COLOR;
    _backView = [[UIControl alloc] init];
    _mobile = [[XHCodeTF alloc] initWithFrame:FRAME(50, 0, WIDTH - 50 - 90, 50)];
    _mobile.placeholder = NSLocalizedString(@"请输入手机号", nil);
    _mobile.textColor = HEX(@"999999", 1.0f);
    _mobile.font = FONT(14);
    _mobile.delegate = self;
    _mobile.keyboardType = UIKeyboardTypeNumberPad;
    _mobile.showCode = SHOW_COUNTRY_CODE;
    __weak typeof(self)weakself = self;
    _mobile.fatherVC = weakself;
    
    _codeBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeBnt.frame = FRAME(WIDTH - 90, 10, 80, 30);
    _codeBnt.layer.cornerRadius = 4.0f;
    _codeBnt.clipsToBounds = YES;
    [_codeBnt setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [_codeBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_codeBnt addTarget:self action:@selector(codeBnt) forControlEvents:UIControlEventTouchUpInside];
    _codeBnt.titleLabel.font = FONT(14);
    [_codeBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    _code = [[UITextField alloc] initWithFrame:FRAME(50, 0, WIDTH - 50, 50)];
    _code.placeholder = NSLocalizedString(@"请输入验证码", nil);
    _code.textColor = HEX(@"999999", 1.0);
    _code.font = FONT(14);
    _code.delegate = self;
    _code.keyboardType = UIKeyboardTypeNumberPad;
    UIButton *codeAndLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    codeAndLogin.frame = FRAME(10, 120, WIDTH - 20, 40);
    [codeAndLogin setTitle:NSLocalizedString(@"验证并登录", nil) forState:UIControlStateNormal];
    [codeAndLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeAndLogin.layer.cornerRadius = 4.0f;
    codeAndLogin.clipsToBounds = YES;
    codeAndLogin.titleLabel.font = FONT(14);
    [codeAndLogin addTarget:self action:@selector(codeAndLogin) forControlEvents:UIControlEventTouchUpInside];
    [codeAndLogin setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [codeAndLogin setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
    [_backView addSubview:codeAndLogin];
    [self creatUI];

}
#pragma mark=======搭建UI界面======
- (void)creatUI
{
   
    _backView.frame = FRAME(0, (NAVI_HEIGHT+10), WIDTH, HEIGHT - (NAVI_HEIGHT+10));
    _backView.backgroundColor = BACK_COLOR;
    [_backView addTarget:self action:@selector(touch_BackView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backView];
    for(int i = 0;i < 2; i++)
    {
        UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, i * 50, WIDTH, 50)];
        [_backView addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(12.5, 15, 15, 20)];
        [backView addSubview:imgView];
        UILabel *thread1 = [[UILabel alloc] initWithFrame:FRAME(39,5, 1, 40)];
        thread1.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [backView addSubview:thread1];
        UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread2.backgroundColor = HEX(@"E6E6E6", 1.0f);
        UIView *thread3 = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
        thread3.backgroundColor = HEX(@"E6E6E6", 1.0f);
        if(i ==0)
        {
            imgView.image = IMAGE(@"iphone");
            [backView addSubview:thread2];
            [backView addSubview:thread3];
            [backView addSubview:_mobile];
            [backView addSubview:_codeBnt];
        }
        else
        {
            imgView.image = IMAGE(@"yanzhengma");
            [backView addSubview:thread3];
            [backView addSubview:_code];
            
        }
        
        
}

}
#pragma mark ========创建定时器===========
- (void)createTimer
{
    _num = 60;
    if(_timer == nil)
    {
        _codeBnt.enabled = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    [_timer fire];
}
#pragma mark ========开启定时器===========
- (void)onTimer
{
    _num--;
    [_codeBnt setTitle:[NSString stringWithFormat:@"%ds",_num] forState:UIControlStateNormal];
    [_codeBnt setBackgroundColor:HEX(@"999999", 0.6f) forState:UIControlStateNormal];
    if(_num == 0)
    {
        [self closeTimer];
    }
}
#pragma mark ========关闭定时器===========
- (void)closeTimer
{
    [_codeBnt setTitle:NSLocalizedString(@"重新获取", nil) forState:UIControlStateNormal];
    [_codeBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    _codeBnt.enabled = YES;
    [_timer invalidate];
    _timer = nil;
}
#pragma mark=======验证并登录按钮点击事件============
- (void)codeAndLogin
{
    NSLog(@"验证并登录");
    if(_mobile.text.length == 0 )
    {
        [self showAlertView:NSLocalizedString(@"手机号不能为空", nil)];
    }
    else if (_code.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"验证码不能为空", nil)];
    }
    else
    {
        SHOW_HUD
        NSString *open_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"openUDID"];
        NSString *register_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
        NSDictionary *dic = @{@"mobile":_mobile.text,@"sms_code":_code.text,@"open_id":(open_id ? open_id : @""),@"register_id":(register_id ? register_id : @"")};
        [HttpTool postWithAPI:@"client/member/passport/login" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"])
            {
                HIDE_HUD
                [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
                [JHShareModel shareModel].token = json[@"data"][@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"uid"] forKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"nickname"] forKey:@"nickName"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [JHShareModel shareModel].phone = _mobile.text;
//                [JPUSHService setTags:[NSSet setWithArray:json[@"data"][@"tags"]] callbackSelector:nil object:self];
//                [JPUSHService setAlias:@"" callbackSelector:nil object:self];
//                [JPUSHService setAlias:json[@"data"][@"uid"] callbackSelector:nil object:self];
            }
            else
            {
                HIDE_HUD
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"抱歉,验证登录失败,原因:%@", nil),json[@"message"]]];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults removeObjectForKey:@"token"];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertView:error.localizedDescription];
        }];
    }
   
}
#pragma mark======验证码按钮点击事件=====
- (void)codeBnt
{
    
    if(_mobile.text.length == 0){
        [self showAlertView:NSLocalizedString(@"手机号不能为空,请重新输入", nil)];
    } else{
        [[NSUserDefaults standardUserDefaults] setObject:_mobile.text forKey:@"SECURITY_MOBILE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([_codeBnt.titleLabel.text isEqualToString:NSLocalizedString(@"重新获取", nil)] || [_codeBnt.titleLabel.text isEqualToString:NSLocalizedString(@"获取验证码", nil)]){
            NSDictionary *dic = @{@"mobile":_mobile.text};
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
                                        [self createTimer];
                                    }
                                }];
                                [_control refesh:json];

                            }else{
                                [self showAlertView:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                            }
                        } failure:^(NSError *error) {
                            [self showAlertView:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                            NSLog(@"%@",error.localizedDescription);
                        }];
                    }else{
                        [self createTimer];
                    }
                    //获取图形验证码
                }else{
                    [self  showAlertView:json[@"message"]];
                }
            } failure:^(NSError *error) {
                NSLog(@"error:%@",error.localizedDescription);
            }];
        }
    }
}
#pragma mark==========键盘退出===============
- (void)touch_BackView
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

@end
