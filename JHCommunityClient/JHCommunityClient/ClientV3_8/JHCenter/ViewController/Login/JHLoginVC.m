//
//  LoginVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/25.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHLoginVC.h"
#import "JHRegisterVC.h"
#import "JHMobileMessageVC.h"
#import "JHForgetPasswordVC.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "MBProgressHUD.h"
 
#import "WXInfoModel.h"
#import "JHWXBindVC.h"
#import "JHShareModel.h"
#import "JPUSHService.h"
#import "XHCodeTF.h"
#import "SecurityCode.h"
#import "JHNewForgetPasswordVC.h"
@interface JHLoginVC ()<UITextFieldDelegate>
{
    UIControl *_backView;//登录背景视图
    XHCodeTF *phoneF;//手机号
    UITextField *passWordF;//密码
    BOOL _isWeixin;
    WXInfoModel *_wxInfoModel;
    BOOL _isMimaLogin;
    
    UIButton *oldBtn;
    NSMutableArray *btnArray;
    UIView * label_seleter;
    UIView *headView;
    UIView *PhoneView;
    int _num;
    NSTimer *_timer;
    UIButton *codeBtn;
    SecurityCode *_control;
    
    
}
@end

@implementation JHLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWXLogin:) name:NSLocalizedString(@"微信登录", nil) object:nil];
    _isMimaLogin = YES;
    _control = [[SecurityCode alloc]init];
    _wxInfoModel = [WXInfoModel shareWXInfoModel];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"登录", nil);
    [self creatUI];
//    [self createregiserBnt];
    [self handle];
    
    if (self.fromFindCode) self.backBtn.hidden = YES;
}
- (void)clickBackBtn{
    
    if(self.fromYunBuy){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatUI
{
    
    UIControl *view =[[UIControl alloc]initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT)];
    [self.view addSubview:view];
    [view addTarget:self action:@selector(touch_BackView) forControlEvents:UIControlEventTouchUpInside];
    [self creatHeaderView];
    
    [self creatPhoneView];
    
    [self creatMore];
    
}
#pragma mark=====处理界面=======
- (void)handle
{

    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if(username.length != 0 && password.length != 0)
    {
        phoneF.text = username;
        passWordF.text = password;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark======微信登录成功或失败后的处理============
- (void)handleWXLogin:(NSNotification *)noti
{
    
        if([_wxInfoModel.wxtype isEqualToString:@"wxlogin"]){
            [self.navigationController popViewControllerAnimated:YES];
            if(self.loginSuccessBlock){
                self.loginSuccessBlock();
            }
        }else{
             JHWXBindVC *bindVc = [[JHWXBindVC alloc] init];
            [self.navigationController pushViewController:bindVc animated:YES];
        }
}
#pragma mark======搭建UI界面===========

-(void)creatHeaderView{
    headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    headView.frame = FRAME(20, 25+NAVI_HEIGHT, WIDTH-40, 40);
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = FRAME((WIDTH-40)/2*i+0.5, 0, (WIDTH-40)/2-0.5, 40);
        [headView addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
            oldBtn = btn;
            [btn setTitle:NSLocalizedString(@"密码登录", nil) forState:UIControlStateNormal];
        }else{
            [btn setTitle:NSLocalizedString(@"短信验证码登录", nil) forState:UIControlStateNormal];
        }
        btn.titleLabel.font = FONT(16);
        btn.tag = i;
        [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnChange:) forControlEvents:UIControlEventTouchUpInside];
        [btnArray addObject:btn];
    }

    //创建底部的分割线
    UIView * label_buttom = [[UIView alloc]init];
    label_buttom.frame = FRAME(0,39.5,WIDTH-40,0.5);
    label_buttom.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [headView addSubview:label_buttom];
    //创建选中时的橙色的显示条
    label_seleter = [[UIView alloc]init];
    label_seleter.frame = FRAME(0,39,(WIDTH-40)/2, 1);
    label_seleter.backgroundColor = THEME_COLOR;
    [headView addSubview:label_seleter];
}

#pragma mark - 这是点击头部按钮的方法
-(void)btnChange:(UIButton *)sender{
    _isMimaLogin = !_isMimaLogin;
    oldBtn.selected = NO;
    sender.selected = !sender.selected;
    oldBtn = sender;
    codeBtn.hidden = !codeBtn.hidden;
    if (!_isMimaLogin) {
        passWordF.placeholder = @"请输入验证码";
        passWordF.secureTextEntry = NO;
        passWordF.text = @"";
    }else{
        passWordF.placeholder = @"请输入密码";
        passWordF.secureTextEntry = YES;
        [self handle];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        label_seleter.frame = FRAME((WIDTH-40)/2*sender.tag, 39, (WIDTH-40)/2, 1);
    }];
   
}
-(void)creatPhoneView{
    
    PhoneView = [[UIView alloc]init];
    [self.view addSubview:PhoneView];
    [PhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset = 20;
        make.left.offset = 20;
        make.right.offset = -20;
        make.height.offset = 100;
    }];
    
    UILabel *phoneL = [[UILabel alloc]init];
    [PhoneView addSubview:phoneL];
    [phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 0;
        make.left.offset = 0;
        make.height.offset = 49;
        make.width.offset = 50;
    }];
    phoneL.text = @"手机号";
    phoneL.textColor = HEX(@"333333", 1);
    phoneL.font = FONT(16);
    
    phoneF = [[XHCodeTF alloc]init];
    [PhoneView addSubview:phoneF];
    [phoneF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 0;
        make.left.equalTo(phoneL.mas_right).offset = 20;
        make.height.offset = 49;
        make.width.offset = WIDTH- 100;
    }];
    phoneF.placeholder = @"请输入手机号";
    phoneF.textColor = HEX(@"999999", 1);
    phoneF.delegate  = self;
    phoneF.keyboardType = UIKeyboardTypeNumberPad;
    phoneF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneF.showCode = SHOW_COUNTRY_CODE;
    __weak typeof(self)weakself = self;
    phoneF.fatherVC = weakself;
    
    UIView *line1 = [[UIView alloc]init];
    [PhoneView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 49;
        make.left.offset = 0;
        make.height.offset = 1;
        make.width.offset = WIDTH- 40;
    }];
    line1.backgroundColor = HEX(@"e5e5e5", 1);
    
    passWordF = [[UITextField alloc]init];
    [PhoneView addSubview:passWordF];
    [passWordF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset = 0;
        make.left.offset = 0;
        make.height.offset = 49;
        make.width.offset = WIDTH-120;
    }];
    passWordF.placeholder = @"请输入密码";
    passWordF.textColor = HEX(@"999999", 1);
    passWordF.delegate = self;
    passWordF.keyboardType = UIKeyboardTypeDefault;
    passWordF.secureTextEntry = YES;
    passWordF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    codeBtn=[[UIButton alloc]init];
    [PhoneView addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset = 0;
        make.right.offset = 0;
        make.height.offset = 49;
        make.width.offset = 80;
    }];
    [codeBtn setTitle:@"获取验证码" forState:0];
    codeBtn.titleLabel.font = FONT(14);
    [codeBtn setTitleColor:THEME_COLOR forState:0];
    [codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    codeBtn.hidden = YES;
    
    UIView *line2 = [[UIView alloc]init];
    [PhoneView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -1;
        make.left.offset = 0;
        make.height.offset = 1;
        make.width.offset = WIDTH- 40;
    }];
    line2.backgroundColor = HEX(@"e5e5e5", 1);
   
}
#pragma mark - 获取验证码
-(void)codeBtnClick{
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

-(void)creatMore{
    
    UIButton *registerBtn = [[UIButton alloc]init];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PhoneView.mas_bottom).offset = 30;
        make.left.offset = 20;
        make.height.offset = 40;
        make.width.offset = (WIDTH- 75)/2;
    }];
    [registerBtn setTitle:@"注册" forState:0];
    [registerBtn setTitleColor:THEME_COLOR forState:0];
    registerBtn.layer.borderWidth = 1.0f;
    registerBtn.layer.borderColor = THEME_COLOR.CGColor;
    registerBtn.titleLabel.font = FONT(16);
    registerBtn.layer.cornerRadius = 2;
    [registerBtn addTarget:self action:@selector(registerBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PhoneView.mas_bottom).offset = 30;
        make.right.offset = -20;
        make.height.offset = 40;
        make.width.offset = (WIDTH- 75)/2;
    }];
    [loginBtn setTitle:@"登录" forState:0];
    [loginBtn setTitleColor:THEME_COLOR_WHITE_Alpha(1) forState:0];
    loginBtn.titleLabel.font = FONT(16);
    [loginBtn setBackgroundColor:THEME_COLOR forState:0];
    loginBtn.layer.cornerRadius = 2;
    [loginBtn addTarget:self action:@selector(loginBnt) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * forgrtBtn = [[UIButton alloc]init];
    [self.view addSubview:forgrtBtn];
    [forgrtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerBtn.mas_bottom).offset = 20;
        make.left.offset = 20;
        make.height.offset = 20;
        make.width.offset = 50;
    }];
    [forgrtBtn setTitle:@"忘记密码" forState:0];
    forgrtBtn.titleLabel.font = FONT(12);
    [forgrtBtn setTitleColor:HEX(@"999999", 1) forState:0];
    [forgrtBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
            [self createWXLogin];
    }

}//JHNewForgetPasswordVC
-(void)forgetBtnClick{
    JHNewForgetPasswordVC *vc = [[JHNewForgetPasswordVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark======手机号登录==============
- (void)loginBnt
{
    if (codeBtn.hidden) {
        NSLog(@"立即登录");
        NSString *open_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"openUDID"];
        NSString *register_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
        NSDictionary *dic = @{@"mobile":phoneF.text,@"passwd":passWordF.text,@"open_id":(open_id ? open_id : @""),@"register_id":(register_id ? register_id : @""),@"sms_code":passWordF.text};
        SHOW_HUD
        [HttpTool postWithAPI:@"client/v3/passport/login" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                HIDE_HUD
                
                if (!self.fromFindCode) [self.navigationController popViewControllerAnimated:YES];
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
                [JHShareModel shareModel].token = json[@"data"][@"token"];
                NSString *username = [(NSArray *)[phoneF.text.mutableCopy componentsSeparatedByString:@"-"] lastObject];
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"nickname"] forKey:@"nickName"];
                [[NSUserDefaults standardUserDefaults] setObject:passWordF.text forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"uid"] forKey:@"uid"];
                [[NSNotificationCenter defaultCenter] postNotificationName:KLogin_success object:nil];
                //            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [JHShareModel shareModel].phone = phoneF.text;
                if(self.loginSuccessBlock){
                    self.loginSuccessBlock();
                }
            }else{
                HIDE_HUD
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"抱歉,登录失败,原因:%@", nil),json[@"message"]]];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults removeObjectForKey:@"token"];
            }
        } failure:^(NSError *error) {
            NSLog(@"error%@",error.localizedDescription);
            HIDE_HUD
            [self showAlertView:error.localizedDescription];
        }];
        
    }else{
    NSLog(@"验证并登录");
    if(phoneF.text.length == 0 )
    {
        [self showAlertView:NSLocalizedString(@"手机号不能为空", nil)];
    }
    else if (passWordF.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"验证码不能为空", nil)];
    }
    else
    {
        SHOW_HUD
        NSString *open_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"openUDID"];
        NSString *register_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
        NSDictionary *dic = @{@"mobile":phoneF.text,@"sms_code":passWordF.text,@"open_id":(open_id ? open_id : @""),@"register_id":(register_id ? register_id : @"")};
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
                [[NSNotificationCenter defaultCenter] postNotificationName:KLogin_success object:nil];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [JHShareModel shareModel].phone = phoneF.text;
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
}
#pragma mark=====创建微信登录按钮==========
- (void)createWXLogin
{
    UIView *wxView = [[UIView alloc]init];
    [self.view addSubview:wxView];
    [wxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset = 0;
        make.height.offset = 140;
    }];
    
    UIView *line = [[UIView alloc]init];
    [wxView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.width.offset = 220;
        make.top.offset= 10;
        make.height.offset = 1;
    }];
    line.backgroundColor = HEX(@"e5e5e5", 1);
    
    UILabel *titleL =[[UILabel alloc]init];
    [wxView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 0;
        make.centerX.offset = 0;
        make.width.offset = 100;
        make.height.offset = 20;
    }];
    titleL.text = @"其他登录方式";
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = HEX(@"666666", 1);
    titleL.font = FONT(14);
    titleL .backgroundColor = THEME_COLOR_WHITE_Alpha(1);
    
    UIButton *wxBtn = [[UIButton alloc]init];
    [wxView addSubview:wxBtn];
    [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset = 18;
        make.centerX.offset = 0;
        make.width.height.offset =60;
    }];
    [wxBtn setBackgroundImage:IMAGE(@"weixin") forState:UIControlStateNormal];
    [wxBtn addTarget:self action:@selector(weixinBnt) forControlEvents:UIControlEventTouchUpInside];
      
}
#pragma mark========微信登录按钮点击事件========
- (void)weixinBnt
{
    NSLog(@"微信登录");
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"0744";
    [WXApi sendReq:req];
    
}
#pragma mark=====忘记密码按钮==========
- (void)forgetBnt
{
    NSLog(@"忘记密码");
    JHForgetPasswordVC *forget = [[JHForgetPasswordVC alloc] init];
    [self.navigationController pushViewController:forget animated:YES];
    
}
#pragma mark=======手机动态登录============
- (void)messageBnt
{
    NSLog(@"手机动态短信登录");
    JHMobileMessageVC *mobileMessage = [[JHMobileMessageVC alloc] init];
    [self.navigationController pushViewController:mobileMessage animated:YES];
}
#pragma mark=========注册按钮点击事件===============
- (void)registerBtn
{
    NSLog(@"注册");
    JHRegisterVC *registerVc = [[JHRegisterVC alloc] init];
    registerVc.index = 2;
    [self.navigationController pushViewController:registerVc animated:YES];
}
#pragma mark=========UITextFieldDelegate===========
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(textField == phoneF)
    {
        passWordF.text = @"";
    }
    return  YES;
}

#pragma mark=======点击屏幕键盘退出==========
- (void)touch_BackView
{
    [self.view endEditing:YES];
}


#pragma mark========返回按钮点击事件===========
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark=======提示框===========
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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSLocalizedString(@"微信登录", nil) object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark ========创建定时器===========
- (void)createTimer
{
    _num = 60;
    if(_timer == nil)
    {
        codeBtn.enabled = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    [_timer fire];
}
#pragma mark ========开启定时器===========
- (void)onTimer
{
    _num--;
    [codeBtn setTitle:[NSString stringWithFormat:@"%ds",_num] forState:UIControlStateNormal];
    [codeBtn setTitleColor:HEX(@"999999", 1.f) forState:UIControlStateNormal];
    if(_num == 0)
    {
        [self closeTimer];
    }
}
#pragma mark ========关闭定时器===========
- (void)closeTimer
{
    [codeBtn setTitle:NSLocalizedString(@"重新获取", nil) forState:UIControlStateNormal];
    [codeBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    codeBtn.enabled = YES;
    [_timer invalidate];
    _timer = nil;
}

@end
