//
//  ChangePhoneVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//更改手机号码

#import "JHChangePhoneVC.h"
#import "MemberInfoModel.h"
#import "JHShareModel.h"
 
#import "SecurityCode.h"
//客服热线
#define HOTLINE @"400-12332145"
@interface JHChangePhoneVC ()<UITextFieldDelegate>
{
    UITextField *_oldPhone;//旧手机号
    UITextField *_oldPassword;//旧密码
    UITextField *_newPhone;//新手机
    UITextField *_code;//验证码
    UIButton *_codeBnt;//验证码按钮
    UIControl *_backView;
    NSTimer *_timer;
    int _num;
    MemberInfoModel *_infoModel;
    SecurityCode *_control;
}
@end

@implementation JHChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoModel = [MemberInfoModel shareModel];
    self.view.backgroundColor = BACK_COLOR;
    self.title = NSLocalizedString(@"换绑手机", nil);
    [self createUI];
    _control = [[SecurityCode alloc] init];
}
#pragma mark=========搭建UI界面==========
- (void)createUI
{
    _oldPhone = [[UITextField alloc] initWithFrame:FRAME(50, 0, WIDTH - 50, 50)];
    _oldPhone.text = self.phone;
    _oldPhone.enabled = NO;
    _oldPhone.textColor = HEX(@"999999", 1.0f);
    _oldPhone.font = FONT(14);
    _oldPhone.delegate = self;
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
    _oldPassword = [[UITextField alloc] initWithFrame:FRAME(50, 0, WIDTH - 50, 50)];
    _oldPassword.placeholder = NSLocalizedString(@"请输入旧手机密码", nil);
    _oldPassword.textColor = HEX(@"999999", 1.0f);
    _oldPassword.font = FONT(14);
    _oldPassword.delegate = self;
    _oldPassword.secureTextEntry = YES;
    _newPhone = [[UITextField alloc] initWithFrame:FRAME(50, 0, WIDTH - 50 - 90, 50)];
    _newPhone.placeholder = NSLocalizedString(@"请输入新手机号", nil);
    _newPhone.textColor = HEX(@"999999", 1.0f);
    _newPhone.font = FONT(14);
    _newPhone.delegate = self;
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
            [backView addSubview:_oldPhone];
        }
        else if(i == 1)
        {
            imgView.image = IMAGE(@"mima");
            [backView addSubview:thread3];
            [backView addSubview:_oldPassword];
            
        }
        else if(i == 2)
        {
            imgView.image = IMAGE(@"iphone");
            [backView addSubview:thread3];
            [backView addSubview:_newPhone];
            [backView addSubview:_codeBnt];
        }
        else
        {
            imgView.image = IMAGE(@"yanzhengma");
            [backView addSubview:thread3];
            [backView addSubview:_code];
        }
    }
    UILabel *describeLabel = [[UILabel alloc] initWithFrame:FRAME( 10, 210, WIDTH - 10, 15)];
    describeLabel.textAlignment = NSTextAlignmentLeft;
    describeLabel.font = FONT(14);
    describeLabel.textColor = HEX(@"999999", 1.0f);
//    describeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"若旧手机丢失请联系客服,客服热线:%@", nil),HOTLINE];
    [_backView addSubview:describeLabel];
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

#pragma mark=======退出键盘==========
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touch_BackView
{
    [self.view endEditing:YES];
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
#pragma mark=======验证码按钮点击事件==========
- (void)codeBnt
{
    NSLog(@"获取验证码");
    if(_oldPhone.text.length == 0){
        [self showAlertView:NSLocalizedString(@"旧手机号不能为空,请重新输入", nil)];
    }else if(_newPhone.text.length == 0){
        [self showAlertView:NSLocalizedString(@"新手机号码不能为空,请重新输入", nil)];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:_newPhone.text forKey:@"SECURITY_MOBILE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([_codeBnt.titleLabel.text isEqualToString:NSLocalizedString(@"重新获取", nil)] || [_codeBnt.titleLabel.text isEqualToString:NSLocalizedString(@"获取验证码", nil)]){

            NSDictionary *dic = @{@"mobile":_newPhone.text};
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
#pragma mark===========立即提交按钮点击事件==============
- (void)submitBnt
{
    NSLog(@"立即提交");
    NSDictionary *dic = @{@"new_mobile":_newPhone.text,@"sms_code":_code.text,@"passwd":_oldPassword.text};
    [HttpTool postWithAPI:@"client/member/updatemobile" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"]  isEqualToString:@"0"])
        {
            [self showAlertView:NSLocalizedString(@"更换手机成功", nil)];
            if (self.myBlock) {
                self.myBlock(_newPhone.text);
            }
            [[NSUserDefaults standardUserDefaults] setObject:_newPhone.text forKey:@"username"];
            [JHShareModel shareModel].phone = _newPhone.text;
        }
        else
        {
           [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"更换手机失败,原因:%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
        
    }];
}
#pragma mark=======提示框===========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if([title isEqualToString:NSLocalizedString(@"更换手机成功", nil)]){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
           
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
