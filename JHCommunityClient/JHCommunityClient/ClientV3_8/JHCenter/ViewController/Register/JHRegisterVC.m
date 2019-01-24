//
//  RegisterVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHRegisterVC.h"
#import "JHNegotiateVC.h"
 
#import "JHShareModel.h"
#import "JPUSHService.h"
#import "SecurityCode.h"
#import "XHCodeTF.h"
#import "JHCodeVC.h"
@interface JHRegisterVC ()<UITextFieldDelegate>
{
    XHCodeTF *phoneF;
    UITextField *_code;
    UITextField *_passwordOne;
    UITextField *_passwordTwo;
    UIButton *_codeBnt;//验证码
    UIButton *_checkBnt;//勾选
    BOOL _isSelected;
    NSTimer *_timer;//定时器
    int _num;
    UIControl *_backView;
    SecurityCode *_control;
    UIButton *getcodeBtn;
}

@end

@implementation JHRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _control = [[SecurityCode alloc] init];
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = BACK_COLOR;
    UILabel *phoneL = [[UILabel alloc]init];
    [self.view addSubview:phoneL];
    [phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 67+NAVI_HEIGHT;
        make.left.offset = 20;
        make.height.offset = 49;
        make.width.offset = 50;
    }];
    phoneL.text = @"手机号";
    phoneL.textColor = HEX(@"333333", 1);
    phoneL.font = FONT(16);
    
    phoneF = [[XHCodeTF alloc]init];
    [self.view addSubview:phoneF];
    [phoneF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneL.mas_top).offset = 0;
        make.left.equalTo(phoneL.mas_right).offset = 20;
        make.height.offset = 49;
        make.width.offset = WIDTH- 100;
    }];
    phoneF.placeholder = [NSString stringWithFormat:@"请输入%d位数的手机号",PhoneLength];
    phoneF.textColor = HEX(@"999999", 1);
    phoneF.delegate  = self;
    phoneF.keyboardType = UIKeyboardTypeNumberPad;
    phoneF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneF.showCode = SHOW_COUNTRY_CODE;
    __weak typeof(self)weakself = self;
    phoneF.fatherVC = weakself;
    [phoneF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *line1 = [[UIView alloc]init];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneF.mas_bottom).offset = 0;
        make.left.offset = 20;
        make.height.offset = 1;
        make.width.offset = WIDTH- 40;
    }];
    line1.backgroundColor = HEX(@"e5e5e5", 1);
    
   getcodeBtn = [[UIButton alloc]init];
    [self.view addSubview:getcodeBtn];
    [getcodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneF.mas_bottom).offset = 30;
        make.left.offset= 20;
        make.right.offset = -20;
        make.height.offset = 44;
    }];
    getcodeBtn.layer.cornerRadius = 2;
    [getcodeBtn setTitle:@"获取验证码" forState:0];
    getcodeBtn.titleLabel.font = FONT(16);
    [getcodeBtn setTitleColor:HEX(@"ffffff", 1) forState:0];
    [getcodeBtn setBackgroundColor:HEX(@"cccccc", 1) forState:0];
    [getcodeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    getcodeBtn.userInteractionEnabled = NO;
    
    UIButton *xiyiBtn = [[UIButton alloc]init];
    [self.view addSubview:xiyiBtn];
    [xiyiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getcodeBtn.mas_bottom).offset = 20;
        make.centerX.offset = 0;
        make.width.offset = 200;
        make.height.offset = 20;
    }];
    [xiyiBtn setTitleColor:HEX(@"999999", 1) forState:0];
    xiyiBtn.titleLabel.font = FONT(12);
    NSString *str = @"注册表示您已同意<<注册协议>>";
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1=[[hintString string]rangeOfString:@"<<注册协议>>"];
    [hintString addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:range1];
    xiyiBtn.titleLabel.attributedText = hintString;
    [xiyiBtn setAttributedTitle:hintString forState:0];
    
    [xiyiBtn addTarget:self action:@selector(xiyiBtnClick) forControlEvents:UIControlEventTouchUpInside];
   
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
#pragma mark - 输入框改变
-(void)textDidChange:(UITextField *)textField{
    if (textField.text.length == PhoneLength) {
       
        [getcodeBtn setBackgroundColor:THEME_COLOR forState:0];
        getcodeBtn.userInteractionEnabled= YES;
    }else{
        [getcodeBtn setBackgroundColor:HEX(@"cccccc", 1) forState:0];
         getcodeBtn.userInteractionEnabled= NO;
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
    [_codeBnt setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
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
#pragma mark - 点击协议按钮
-(void)xiyiBtnClick{
    NSLog(@"同意协议");
    JHNegotiateVC *negotiateVc = [[JHNegotiateVC alloc] init];
    [self.navigationController pushViewController:negotiateVc animated:YES];
    
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
                    NSLog(@"%@",json);
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
#pragma mark - 下个界面
-(void)pushtoNext{
    JHCodeVC *vc =[[JHCodeVC alloc]init];
    vc.fromVC = @"JHRegisterVC";
    vc.phoneS = phoneF.text;
    [self.navigationController pushViewController:vc animated:YES];
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
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [UIView animateWithDuration:0.4 animations:^{
//        _backView.frame=CGRectMake(0, (NAVI_HEIGHT+10), WIDTH, HEIGHT);
//    }];
//}
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
