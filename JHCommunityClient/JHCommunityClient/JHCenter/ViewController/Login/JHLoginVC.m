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
#import "HttpTool.h"
#import "WXInfoModel.h"
#import "JHWXBindVC.h"
#import "JHShareModel.h"
#import "JPUSHService.h"
#import "JHHomePageVC.h"
#import "XHCodeTF.h"
#import "MemberInfoModel.h"
@interface JHLoginVC ()<UITextFieldDelegate>
{
    UIControl *_backView;//登录背景视图
    XHCodeTF *_mobile;//手机号
    UITextField *_password;//密码
    BOOL _isWeixin;
    WXInfoModel *_wxInfoModel;
}
@end

@implementation JHLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wxInfoModel = [WXInfoModel shareWXInfoModel];
    self.view.backgroundColor = BACK_COLOR;
    self.title = NSLocalizedString(@"登录", nil);
    [self creatUI];
    [self createregiserBnt];
    [self handle];
    
    if (self.fromFindCode) self.backBtn.hidden = YES;
}
- (void)clickBackBtn{
    
    if(self.fromYunBuy){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
        [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark=====处理界面=======
- (void)handle
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWXLogin:) name:NSLocalizedString(@"微信登录", nil) object:nil];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if(username.length != 0 && password.length != 0)
    {
        _mobile.text = username;
        _password.text = password;
    }
}
#pragma mark=====创建注册按钮======
- (void)createregiserBnt
{
    UIButton *registerBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBnt.frame = FRAME(0, 0, 30, 15);
    [registerBnt setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [registerBnt addTarget:self action:@selector(registerBnt) forControlEvents:UIControlEventTouchUpInside];
    registerBnt.titleLabel.font = FONT(14);
    [registerBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:registerBnt];
    self.navigationItem.rightBarButtonItem = rightItem;
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
        if (!self.fromFindCode) {
            [self createWXLogin];
  
        }
    }
    
    if (self.fromFindCode) {

        registerBnt.hidden = YES;
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
- (void)creatUI
{
    _backView = [[UIControl alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT)];
    _backView.backgroundColor = BACK_COLOR;
    [_backView addTarget:self action:@selector(touch_BackView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backView];
    UIView *mobileView = [[UIView alloc] initWithFrame:FRAME(0, 5, WIDTH,50)];
    mobileView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:mobileView];
    UIView *passwordView = [[UIView alloc] initWithFrame:FRAME(0, 60, WIDTH, 50)];
    passwordView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:passwordView];
    UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    thread1.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [mobileView addSubview:thread1];
    UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
    thread2.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [mobileView addSubview:thread2];
    UIView *thread3 = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
    thread3.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [passwordView addSubview:thread3];
    UIView *thread4 = [[UIView alloc] initWithFrame:FRAME(39, 5, 1, 40)];
    thread4.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [mobileView addSubview:thread4];
    UIView *thread5 = [[UIView alloc] initWithFrame:FRAME(39, 5, 1, 40)];
    thread5.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [passwordView addSubview:thread5];
    _mobile = [[XHCodeTF alloc] initWithFrame:FRAME(50, 0, WIDTH - 50, 50)];
    _mobile.placeholder = NSLocalizedString(@"请输入手机号", nil);
    _mobile.textColor = HEX(@"999999", 1.0f);
    _mobile.font = FONT(14);
    _mobile.delegate = self;
    _mobile.keyboardType = UIKeyboardTypeNumberPad;
    _mobile.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobile.showCode = SHOW_COUNTRY_CODE;
    __weak typeof(self)weakself = self;
    _mobile.fatherVC = weakself;
    
    [mobileView addSubview:_mobile];
    _password = [[UITextField alloc] initWithFrame:FRAME(50, 0, WIDTH - 50, 50)];
    _password.placeholder = NSLocalizedString(@"请输入密码", nil);
    _password.font = FONT(14);
    _password.delegate = self;
    _password.textColor = HEX(@"999999", 1.0f);
    _password.secureTextEntry = YES;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordView addSubview:_password];
    UIImageView *mobileImg = [[UIImageView alloc] initWithFrame:FRAME(12.5, 15, 15, 20)];
    mobileImg.image = IMAGE(@"iphone");
    [mobileView addSubview:mobileImg];
    UIImageView *passwordImg = [[UIImageView alloc] initWithFrame:FRAME(11.5, 17.5,17, 20)];
    passwordImg.image = IMAGE(@"mima");
    [passwordView addSubview:passwordImg];
    UIButton *loginBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBnt.frame = FRAME(10, 75 + 60 * 1.3 + 60, WIDTH - 20, 40);
    [loginBnt setTitle:NSLocalizedString(@"立即登录", nil) forState:UIControlStateNormal];
    loginBnt.titleLabel.font = FONT(14);
    [loginBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [loginBnt setBackgroundColor:HEX(@"59c181", 0.6) forState:UIControlStateHighlighted];
    loginBnt.layer.cornerRadius = 4.0f;
    loginBnt.clipsToBounds = YES;
    [loginBnt addTarget:self action:@selector(loginBnt) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:loginBnt];
    UIButton *messageBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBnt.frame = FRAME(10, 75 + 60 * 1.3 + 110, 120, 10);
    [messageBnt setTitle:NSLocalizedString(@"手机动态短信登录", nil) forState:UIControlStateNormal];
    messageBnt.titleLabel.font = FONT(14);
    [messageBnt setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [messageBnt setTitleColor:HEX(@"59c181", 0.6) forState:UIControlStateHighlighted];
    [messageBnt addTarget:self action:@selector(messageBnt) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:messageBnt];
    UIButton *forgetBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBnt.frame = FRAME(WIDTH - 10 - 80, 75 + 60 * 1.3 + 110, 80, 10);
    [forgetBnt addTarget:self action:@selector(forgetBnt) forControlEvents:UIControlEventTouchUpInside];
    [forgetBnt setTitle:NSLocalizedString(@"忘记密码?", nil) forState:UIControlStateNormal];
    forgetBnt.titleLabel.font = FONT(14);
    [forgetBnt setTitleColor:HEX(@"999999", 1.0f) forState:UIControlStateNormal];
    [forgetBnt setTitleColor:HEX(@"999999", 0.6) forState:UIControlStateHighlighted];
    [_backView addSubview:forgetBnt];
    
    if (self.fromFindCode) {
        messageBnt.hidden = YES;
        forgetBnt.hidden = YES;
  
    }
}
#pragma mark======手机号登录==============
- (void)loginBnt
{
    NSLog(@"立即登录");
    NSString *open_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"openUDID"];
    NSString *register_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
    NSDictionary *dic = @{@"mobile":_mobile.text,@"passwd":_password.text,@"open_id":(open_id ? open_id : @""),@"register_id":(register_id ? register_id : @"")};
    SHOW_HUD
    [HttpTool postWithAPI:@"client/member/passport/login" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
           
            if (!self.fromFindCode) [self.navigationController popViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
            [JHShareModel shareModel].token = json[@"data"][@"token"];
            NSString *username = [(NSArray *)[_mobile.text.mutableCopy componentsSeparatedByString:@"-"] lastObject];
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"nickname"] forKey:@"nickName"];
            [[NSUserDefaults standardUserDefaults] setObject:_password.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"uid"] forKey:@"uid"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KLogin_success object:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [JHShareModel shareModel].phone = _mobile.text;
            [self getMoney];
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
    
}
- (void)getMoney{
    [HttpTool postWithAPI:@"client/member/info" withParams:@{} success:^(id json) {

        if([json[@"error"] isEqualToString:@"0"]){
            [[MemberInfoModel shareModel] setValuesForKeysWithDictionary:json[@"data"]];
        }
    } failure:^(NSError *error) {
       
    }];
}
#pragma mark=====创建微信登录按钮==========
- (void)createWXLogin
{
    UIView *thread6 = [[UIView alloc] initWithFrame:FRAME(10, 75 + 60 * 1.3 + 120 + 55.5,(WIDTH -100)/2,0.5)];
    thread6.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [_backView addSubview:thread6];
    UILabel *third = [[UILabel alloc] initWithFrame:FRAME(15 + (WIDTH - 100)/2, 75 + 60 * 1.3 + 120 + 50, 80, 10)];
    third.textColor = HEX(@"999999", 1.0f);
    third.text = NSLocalizedString(@"第三方账号登录", nil);
    third.font = FONT(10);
    third.textAlignment = NSTextAlignmentLeft;
    [_backView addSubview:third];
    UIView *thread7 = [[UIView alloc] initWithFrame:FRAME(15 + (WIDTH -100)/2 + 75, 75 + 60 * 1.3 + 120 + 55.5,(WIDTH - 100)/2,0.5)];
    thread7.backgroundColor = HEX(@"E6E6E6", 1.0f);
    [_backView addSubview:thread7];
    UIButton *weixinBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBnt.frame = FRAME((WIDTH - 40)/2, 75 + 60 * 1.3 + 120 + 70, 40, 40);
    [weixinBnt setBackgroundImage:IMAGE(@"weixin") forState:UIControlStateNormal];
    [weixinBnt addTarget:self action:@selector(weixinBnt) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:weixinBnt];
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
- (void)registerBnt
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
    if(textField == _mobile)
    {
        _password.text = @"";
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
@end
