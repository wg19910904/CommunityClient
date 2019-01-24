//
//  ForgetPasswordVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/27.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHForgetPasswordVC.h"
 
#import "SecurityCode.h"
#import "JHLoginVC.h"
#import "XHCodeTF.h"
@interface JHForgetPasswordVC ()<UITextFieldDelegate>
{
    XHCodeTF *_mobile;
    UITextField *_code;
    UITextField *_passwordOne;
    UITextField *_passwordTwo;
    UIButton *_codeBnt;//验证码
    NSTimer *_timer;//定时器
    int _num;
    UIControl *_backView;
    SecurityCode *_control;
}
@end

@implementation JHForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"找回密码", nil);
    _control = [[SecurityCode alloc] init];
    _mobile = [[XHCodeTF alloc] initWithFrame:FRAME(50, 0, WIDTH - 50 - 90, 50)];

    _mobile.placeholder = NSLocalizedString(@"请输入手机号", nil);

    _mobile.textColor = HEX(@"999999", 1.0f);
    _mobile.font = FONT(14);
    _mobile.keyboardType = UIKeyboardTypeNumberPad;
    _mobile.delegate = self;
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
    _code.textColor = HEX(@"999999", 1.0f);
    _code.font = FONT(14);
    _code.delegate = self;
    _code.keyboardType = UIKeyboardTypeNumberPad;
    _passwordOne = [[UITextField alloc] initWithFrame:FRAME(50, 0, WIDTH - 50, 50)];
    _passwordOne.placeholder = NSLocalizedString(@"请输入新密码", nil);
    _passwordOne.textColor = HEX(@"999999", 1.0f);
    _passwordOne.font = FONT(14);
    _passwordOne.delegate = self;
    _passwordTwo = [[UITextField alloc] initWithFrame:FRAME(50, 0, WIDTH - 50, 50)];
    _passwordTwo.placeholder = NSLocalizedString(@"请再输入密码", nil);
    _passwordTwo.textColor = HEX(@"999999", 1.0f);
    _passwordTwo.font = FONT(14);
    _passwordTwo.delegate = self;
    _passwordOne.secureTextEntry = YES;
    _passwordTwo.secureTextEntry = YES;
    [self createUI];
    
    
}
#pragma  mark========创建UI界面============
- (void)createUI
{
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
            [backView addSubview:_mobile];
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
    submitBnt.frame = FRAME(10, 65 + 10 + 3 * 50 + 20, WIDTH - 20, 40);
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
#pragma mark======立即提交========
- (void)submitBnt
{
    NSLog(@"立即提交");
    if(_mobile.text.length == 0 || _code.text.length == 0 || _passwordOne.text.length == 0 || _passwordTwo.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"亲,请完善相关信息哦", nil)];
    }
    if(_passwordOne.text.length < 6 || _passwordTwo.text.length < 6)
    {
        [self showAlertView:NSLocalizedString(@"输入的密码不能少于6位,请重新输入", nil)];
    }
    if(![_passwordOne.text isEqualToString:_passwordTwo.text])
    {
        [self showAlertView:NSLocalizedString(@"两次密码不相同,请重新输入", nil)];
    }
    if(_mobile.text.length > 0 && _code.text.length > 0 && _passwordOne.text.length > 0 &&_passwordTwo.text.length > 0 &&([_passwordOne.text isEqualToString:_passwordTwo.text]))
    {
        NSDictionary *dic = @{@"mobile":_mobile.text,@"new_passwd":_passwordOne.text,@"sms_code":_code.text,};
        [HttpTool postWithAPI:@"client/member/passport/forgot" withParams:dic success:^(id json) {
            NSLog(@"json%@====%@",json,json[@"message"]);
            if([json[@"error"] isEqualToString:@"0"]) {
                UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"密码找回成功", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    self.backBtn.userInteractionEnabled = NO;
//                    //密码找回后,需要重新登录
//                    JHLoginVC *vc = [JHLoginVC new];
//                    vc.loginSuccessBlock = ^{
//
//                        NSInteger count = self.navigationController.viewControllers.count;
//                        UIViewController *vc2 = self.navigationController.viewControllers[count-3];
//                        [self.navigationController popToViewController:vc2 animated:YES];
//                    };
//                    vc.fromFindCode = YES;
//                    [self.navigationController pushViewController:vc animated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                [alertViewController addAction:cancelAction];
                [self presentViewController:alertViewController animated:YES completion:nil];
            }
            else
            {
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"抱歉,密码找回失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertView:error.localizedDescription];
        }];
    }
    
}
#pragma mark=========UITextFieldDelegate===========
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
#pragma mark=======点击屏幕键盘退出==========
- (void)touch_BackView
{
    [self.view endEditing:YES];
}
#pragma mark=======验证码按钮点击事件==========
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

- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
