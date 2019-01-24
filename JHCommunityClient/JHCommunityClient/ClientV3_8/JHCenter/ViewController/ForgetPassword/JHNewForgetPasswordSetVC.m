//
//  JHNewForgetPasswordSetVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/28.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHNewForgetPasswordSetVC.h"
 
#import "JHLoginVC.h"
@interface JHNewForgetPasswordSetVC ()<UITextFieldDelegate>{
    UITextField *passWordF;
    UIButton *sureBtn;
    
}

@end

@implementation JHNewForgetPasswordSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重置密码";
    
    [self creatUI];
    
}
-(void)creatUI{
    
    passWordF = [[UITextField alloc]init];
    [self.view addSubview:passWordF];
    [passWordF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 67+NAVI_HEIGHT;
        make.left.offset  = 20;
        make.height.offset = 49;
        make.width.offset = WIDTH - 40;
    }];
    passWordF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWordF.delegate = self;
    [passWordF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    passWordF.placeholder = @"请输入新的登录密码";
    passWordF.secureTextEntry = YES;
    
    UIView *lineV = [[UIView alloc]init];
    [self.view addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passWordF.mas_bottom).offset = 0;
        make.height.offset = 1;
        make.left.offset = 20;
        make.right.offset = -20;
    }];
    lineV.backgroundColor = HEX(@"e5e5e5", 1);
    
    
    UILabel *desL= [[UILabel alloc]init];
    [self.view addSubview:desL];
    [desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV.mas_bottom).offset = 10;
        make.height.offset = 20;
        make.left.offset = 20;
        make.right.offset = -20;
        
    }];
    desL.text = @"密码需为6-18位数字和英文的组合";
    desL.numberOfLines = 0;
    desL.textColor = HEX(@"999999", 1);
    
    sureBtn = [[UIButton alloc]init];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desL.mas_bottom).offset = 30;
        make.height.offset = 44;
        make.left.offset = 12;
        make.right.offset = -12;
    }];
    [sureBtn setTitle:@"完成并登录" forState:0];
    [sureBtn setBackgroundColor:HEX(@"cccccc", 1) forState:0];
    sureBtn.userInteractionEnabled = NO;
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)sureBtnClick{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/v3/passport/forgot" withParams:@{@"mobile" : self.phoneS,@"passwd" : passWordF.text,} success:^(id json) {
        if([json[@"error"] isEqualToString:@"0"]){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:passWordF.text forKey:@"password"];
            [self showMsg:json[@"message"]];
             self.tabBarController.selectedIndex = 4;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            [self showMsg:json[@"message"]];
        }
    } failure:^(NSError *error) {
        [self showNoNetOrBusy:YES];
    }];
    
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0){
        return YES;
    }
    if (textField.text.length == 18) {
        return NO;
    }else{
        
        return YES;
    }
    
    
}
-(void)textDidChange:(UITextField *)textField{
    
    if (textField.text.length >= 6) {
        
        [sureBtn setBackgroundColor:THEME_COLOR forState:0];
        sureBtn.userInteractionEnabled= YES;
    }else{
        [sureBtn setBackgroundColor:HEX(@"cccccc", 1) forState:0];
        sureBtn.userInteractionEnabled= NO;
    }
    
}


@end
