//
//  JHCodeVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHCodeVC.h"
#import "YN_PassWordView.h"
 
#import "SecurityCode.h"
#import "JHNewChangePhoneVC.h"
#import "JHNewSetVC.h"
#import "JHNewMyCenter.h"
#import "JHNewForgetPasswordSetVC.h"
#import "WXInfoModel.h"
#import "JHShareModel.h"
#import "JHRegisterPassWordVC.h"
@interface JHCodeVC ()
{
    UILabel *titleL;
    SecurityCode *_control;
    YN_PassWordView *codeV;
    UILabel *desL;
    UIButton *codeBtn;
    NSString *codeStr;
    int _num;
    NSTimer *_timer;
    NSInteger type;
    WXInfoModel *_wxInfoModel;
    
}

@end

@implementation JHCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wxInfoModel = [WXInfoModel shareWXInfoModel];
    self.navigationItem.title = @"输入验证码";
    [self initData];
    [self creatUI];
    
    
 
}
#pragma mark - 处理数据
-(void)initData{
     _control = [[SecurityCode alloc] init];
    if ([self.fromVC isEqualToString:@"JHNewSetVC"] ||[self.fromVC isEqualToString:@"JHNewForgetPasswordVC"]) {
        type = 1;
    }else{
        type =2;
    }
    
}
-(void)creatUI{
    titleL = [[UILabel alloc]init];
    [self.view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 20+NAVI_HEIGHT;
        make.centerX.offset = 0;
        make.width.offset = WIDTH;
        make.height.offset =18;
    }];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = HEX(@"999999", 1);
    titleL.font = FONT(12);
    titleL.text= [NSString stringWithFormat:@"验证码已发送至手机：%@",self.phoneS];
    
    codeV = [[YN_PassWordView alloc]initWithFrame:CGRectMake(30, 77+NAVI_HEIGHT, WIDTH-60, 40)];
    [self.view addSubview:codeV];
    [codeV.textF becomeFirstResponder];
    __weak typeof(self) weakSelf = self;
    codeV.textBlock = ^(NSString *str) {
        codeStr = str;
        [weakSelf checksms];
    };
    
    
    desL = [[UILabel alloc]init];
    [self.view addSubview:desL];
    [desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeV.mas_bottom).offset = 20;
        make.left.offset = 30;
        make.width.offset = 100;
        make.height.offset =18;
    }];
    desL.textColor = HEX(@"999999", 1);
    desL.font = FONT(12);
    
    
    
    codeBtn = [[UIButton alloc]init];
    [self.view addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeV.mas_bottom).offset = 20;
        make.right.offset = -30;
        make.width.offset = 100;
        make.height.offset =18;
    }];
    //    timeL.textColor = HEX(@"999999", 1);
    codeBtn.titleLabel.font = FONT(14);
    [self createTimer];
    [codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 获取验证码
-(void)codeBtnClick{
    
      SHOW_HUD
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneS forKey:@"SECURITY_MOBILE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *dic = @{@"mobile":self.phoneS};
    [HttpTool postWithAPI:@"magic/sendsms" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        HIDE_HUD
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
                        [self showToastAlertMessageWithTitle:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                    }
                } failure:^(NSError *error) {
                    [self showToastAlertMessageWithTitle:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                    NSLog(@"%@",error.localizedDescription);
                }];
            }else{
               [self createTimer];
                
            }
            //获取图形验证码
        }else{
            [self showToastAlertMessageWithTitle:json[@"message"]];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
    }];
}

-(void)checksms{
    
    SHOW_HUD
    [HttpTool postWithAPI:@"magic/checksms" withParams:@{@"mobile":self.phoneS,@"sms_code":codeStr,@"type":@(type)} success:^(id json) {
        NSLog(@"%@",json);
         HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
           
            if ([self.fromVC isEqualToString:@"JHNewSetVC"]) {
                JHNewChangePhoneVC *vc = [[JHNewChangePhoneVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if([self.fromVC isEqualToString:@"JHNewChangePhoneVC"]){//返回到设置界面
                [self updatePhone];
            }else if([self.fromVC isEqualToString:@"JHNewForgetPasswordVC"]){
                JHNewForgetPasswordSetVC *vc = [[JHNewForgetPasswordSetVC alloc]init];
                vc.phoneS = self.phoneS;
                [self.navigationController pushViewController:vc animated:YES];
              
            }else if([self.fromVC isEqualToString:@"JHWXBindVC"]){
                [self wxBing];
                
            }else if([self.fromVC isEqualToString:@"JHRegisterVC"]){
                JHRegisterPassWordVC *vc = [[JHRegisterPassWordVC alloc]init];
                vc.phoneS = self.phoneS;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }
        }else{
            
            [self showAlertView:json[@"message"]];
            
        }
        
        
    } failure:^(NSError *error) {
        [self showHaveNoMoreData];
    }];
  
}
#pragma mark - 更换手机号
-(void)updatePhone{
 
     SHOW_HUD
    [HttpTool postWithAPI:@"client/v3/member/member/updatemobile" withParams:@{@"new_mobile":self.phoneS,@"sms_code" : codeStr,} success:^(id json) {
            NSLog(@"%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[JHNewSetVC class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }else{
            [self showAlertView:json[@"message"]];
        }
    } failure:^(NSError *error) {
         [self showNoNetOrBusy:YES];
    }];
    
    
    
}
#pragma mark - 微信绑定
-(void)wxBing{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"正在载入...";
    hud.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSDictionary *dic = @{@"mobile":self.phoneS,@"sms_code":codeStr,@"wx_openid":_wxInfoModel.wx_openid,@"wx_unionid":_wxInfoModel.wx_unionid,@"wx_nickname":_wxInfoModel.wx_nickname,@"wx_headimgurl":_wxInfoModel.wx_headimgurl};
    [HttpTool postWithAPI:@"client/v3/passport/wxbind" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"])
        {
            HIDE_HUD_FOR_VIEW(self.view)
            _wxInfoModel.wxtype = @"wxlogin";
            [self.navigationController popToViewController:self.navigationController.viewControllers[3] animated:YES];
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"wxbindsuccess" object:nil];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            [JHShareModel shareModel].phone = self.phoneS;
            [self showToastAlertMessageWithTitle:json[@"message"]];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[JHNewMyCenter class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }else{
                    self.tabBarController.selectedIndex = 0;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
          
            
        }else{
            HIDE_HUD_FOR_VIEW(self.view)
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"抱歉,微信绑定失败,原因:%@", nil),json[@"message"]]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
        }
    } failure:^(NSError *error) {
        HIDE_HUD_FOR_VIEW(self.view)
        NSLog(@"error==%@====",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
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
    [codeBtn setTitle:[NSString stringWithFormat:@"%ds后重发",_num] forState:UIControlStateNormal];
    [codeBtn setTitleColor:HEX(@"999999", 1) forState:0];
    
    if(_num == 0)
    {
        [self closeTimer];
    }
}
#pragma mark ========关闭定时器===========
- (void)closeTimer
{
    [codeBtn setTitle:NSLocalizedString(@"重新获取", nil) forState:UIControlStateNormal];
    [codeBtn setTitleColor:THEME_COLOR forState:0];
    codeBtn.enabled = YES;
    [_timer invalidate];
    _timer = nil;
}
- (void)showAlertView:(NSString *)title{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [_timer invalidate];
//    _timer = nil;
//}


@end
