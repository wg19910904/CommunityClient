//
//  JHRegisterPassWordVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHRegisterPassWordVC.h"
 
#import "JHShareModel.h"
@interface JHRegisterPassWordVC ()<UITextFieldDelegate>{
    UITextField *passWordF;
    UIButton *sureBtn;
    
}

@end

@implementation JHRegisterPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    passWordF.placeholder = @"请设置登录密码";
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
    
    [HttpTool postWithAPI:@"client/v3/passport/register" withParams:@{@"mobile":self.phoneS,@"passwd":passWordF.text} success:^(id json) {
                    if([json[@"error"] isEqualToString:@"0"])
                    {
                        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
                        [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
                        [JHShareModel shareModel].token = json[@"data"][@"token"];
                        [[NSUserDefaults standardUserDefaults] setObject:self.phoneS forKey:@"username"];
                        [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"nickname"] forKey:@"nickName"];
                        [[NSUserDefaults standardUserDefaults] setObject:passWordF.text forKey:@"password"];
                         [JHShareModel shareModel].phone = self.phoneS;
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    else
                    {
                        [self showMsg:[NSString stringWithFormat:NSLocalizedString(@"抱歉,注册失败,原因:%@", nil),json[@"message"]]];
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults removeObjectForKey:@"token"];
                    }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error.localizedDescription);
       [self showMsg:error.localizedDescription];
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
