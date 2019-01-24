//
//  ChangePasswordVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHChangePasswordVC.h"
 
#import "MemberInfoModel.h"
#import "SecurityCode.h"
@interface JHChangePasswordVC ()<UITextFieldDelegate>
{
    UITextField *_phone;
    UITextField *_code;
    UITextField *_passwordOne;
    UITextField *_passwordTwo;
    UIButton *_codeBnt;
    UIControl *_backView;
    NSTimer *_timer;
    int _num;
    MemberInfoModel *_infoModel;
    SecurityCode *_control;
}
@end

@implementation JHChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR;
    _infoModel = [MemberInfoModel shareModel];
    self.title = NSLocalizedString(@"登录密码修改", nil);
    [self createUI];
    _control = [[SecurityCode alloc] init];
}
#pragma  mark========搭建UI界面===========
- (void)createUI
{
    _phone = [[UITextField alloc] initWithFrame:FRAME(50, 0, WIDTH - 50 - 90, 50)];
    _phone.placeholder = NSLocalizedString(@"请输入手机号", nil);
    _phone.text = _infoModel.mobile;
    _phone.textColor = HEX(@"999999", 1.0f);
    _phone.font = FONT(14);
    _phone.delegate = self;
    _phone.enabled = NO;
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
    _code.textColor = HEX(@"999999", 1.0f);
    _code.font = FONT(14);
    _code.delegate = self;
    _passwordOne = [[UITextField alloc] initWithFrame:FRAME(50, 0, WIDTH - 50, 50)];
    _passwordOne.placeholder = NSLocalizedString(@"请输入密码(不少于6位)", nil);
    _passwordOne.textColor = HEX(@"999999", 1.0f);
    _passwordOne.font = FONT(14);
    _passwordOne.delegate = self;
    _passwordOne.secureTextEntry = YES;
    _passwordTwo = [[UITextField alloc] initWithFrame:FRAME(50, 0, WIDTH - 50, 50)];
    _passwordTwo.placeholder = NSLocalizedString(@"请输入密码(不少于6位)", nil);
    _passwordTwo.textColor = HEX(@"999999", 1.0f);
    _passwordTwo.font = FONT(14);
    _passwordTwo.delegate = self;
    _passwordTwo.secureTextEntry = YES;
    _backView = [[UIControl alloc] initWithFrame:FRAME(0, (NAVI_HEIGHT+10), WIDTH, HEIGHT - (NAVI_HEIGHT+10))];
    _backView.backgroundColor = BACK_COLOR;
    [_backView addTarget:self action:@selector(touch_BackView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backView];
    for(int i = 0;i < 4; i++)
    {
        UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, i * 50, WIDTH, 50)];
        [_backView addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(12.5, 15, 15, 20)];
        [backView addSubview:imgView];
        UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(39, 5, 1, 40)];
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
            [backView addSubview:_phone];
            [backView addSubview:_codeBnt];
        }
        else if(i == 1)
        {
            imgView.image = IMAGE(@"yanzhengma");
            [backView addSubview:thread3];
            [backView addSubview:_code];
            
        }
        else if(i == 2)
        {
            imgView.image = IMAGE(@"mima");
            [backView addSubview:thread3];
            [backView addSubview:_passwordOne];
        }
        else
        {
            imgView.image = IMAGE(@"mima");
            [backView addSubview:thread3];
            [backView addSubview:_passwordTwo];
        }
    }
    UIButton *submitBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBnt.frame = FRAME(10, 250, WIDTH - 20, 40);
    [submitBnt setTitle:NSLocalizedString(@"立即提交", nil) forState:UIControlStateNormal];
    [submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBnt.layer.cornerRadius = 4.0f;
    submitBnt.clipsToBounds = YES;
    submitBnt.titleLabel.font = FONT(14);
    [submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [submitBnt setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
    [submitBnt addTarget:self action:@selector(submitBnt) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:submitBnt];
    
}
#pragma mark=======验证码按钮点击事件==========
- (void)codeBnt
{
    NSLog(@"获取验证码");
    
    
    if(_phone.text.length == 0){
        [self showAlertView:NSLocalizedString(@"手机号不能为空,请重新输入", nil)];
    } else{
        [[NSUserDefaults standardUserDefaults] setObject:_phone.text forKey:@"SECURITY_MOBILE"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        if([_codeBnt.titleLabel.text isEqualToString:NSLocalizedString(@"重新获取", nil)] || [_codeBnt.titleLabel.text isEqualToString:NSLocalizedString(@"获取验证码", nil)]){

            NSDictionary *dic = @{@"mobile":_phone.text};
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

#pragma mark==========立即提交按钮点击事件===========
- (void)submitBnt
{
    NSLog(@"修改密码立即提交");
    if(_code.text.length == 0 || _phone.text.length == 0 || _passwordTwo.text.length == 0 || _passwordOne.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"亲,请完善相关信息哦", nil)];
    }
   else if(_passwordOne.text.length < 6 || _passwordTwo.text.length < 6)
    {
        [self showAlertView:NSLocalizedString(@"密码不能少于6位", nil)];
    }
   else if(![_passwordTwo.text isEqualToString:_passwordOne.text])
    {
        [self showAlertView:NSLocalizedString(@"两次密码不相同", nil)];
    }
    else
    {
        NSDictionary *dic = @{@"new_passwd":_passwordOne.text,@"sms_code":_code.text};
        [HttpTool postWithAPI:@"client/member/passwd" withParams:dic success:^(id json) {
            if([json[@"error"]  isEqualToString:@"0"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:_passwordOne.text forKey:@"password"];
                 [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"密码修改成功,请重新登录!", nil),json[@"message"]]];
            }
            else
            {
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"修改密码失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertView:error.localizedDescription];
            
        }];

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
#pragma mark========当开始编辑键盘弹出时将组件向上移=======
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = _backView.frame;
        rect.origin.y -= 10;
        _backView.frame = rect;
    }];
}
#pragma mark ======当结束编辑时将组件的frame还原=======
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 animations:^{
        _backView.frame=CGRectMake(0, (NAVI_HEIGHT+10), WIDTH, HEIGHT);
    }];
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
#pragma mark=======提示框===========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
@end
