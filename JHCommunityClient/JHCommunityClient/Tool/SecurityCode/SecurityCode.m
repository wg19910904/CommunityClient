//
//  SecurityCode.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "SecurityCode.h"
 
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "JHShowAlert.h"
@implementation SecurityCode
{
    UIView * view;
    UITextField * myTextField;
    UILabel * label_error;
    UIImageView * displayImageView;
    UIButton *bj_view;
    UIImageView * imageView;
    UIImageView * imageV;
    UIButton * btn_true;
    UIButton * btn_cancel;
    UILabel * label;
}
-(id)init{
    self = [super init];
    if (self) {
        view = [[UIView alloc]init];
        myTextField = [[UITextField alloc]init];
        bj_view = [[UIButton alloc]init];
        imageView = [[UIImageView alloc]init];
        imageV = [[UIImageView alloc]init];
        btn_true = [[UIButton alloc]init];
        btn_cancel = [[UIButton alloc]init];
        label_error = [[UILabel alloc]init];
        label = [[UILabel alloc]init];
    }
    return self;
}
//展示本地图片验证
-(void)showSecurityViewWithBlock:(void(^)(NSString * result,NSString * code))myBlock{
    self.frame = FRAME(0, 0, WIDTH, HEIGHT);
    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [self addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    view.frame = FRAME(20, 180, WIDTH - 40, 140);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 3;
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    //显示提醒的
    label.frame = FRAME(10, 15, 120, 20);
    label.text = NSLocalizedString(@"请填写图形验证码", nil);
    label.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    //显示输入框的
    myTextField.delegate = self;
    myTextField.frame = FRAME(10, 45, WIDTH - 60, 40);
    myTextField.placeholder = NSLocalizedString(@"请输入图中内容", nil);
    myTextField.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    myTextField.layer.cornerRadius = 3;
    myTextField.layer.masksToBounds = YES;
    myTextField.clearButtonMode = UITextFieldViewModeAlways;
    myTextField.rightViewMode = UITextFieldViewModeAlways;
    [view addSubview:myTextField];
    //展示图片的view
    bj_view = [[UIButton alloc]init];
    bj_view.frame = FRAME(0, 0, 130, 40);
    bj_view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [bj_view addTarget:self action:@selector(clickToUpData) forControlEvents:UIControlEventTouchUpInside];
    myTextField.rightView = bj_view;
    imageView = [[UIImageView alloc]init];
    imageView.frame = FRAME(5, 5, 90, 30);
    [bj_view addSubview:imageView];
    displayImageView = imageView;
    imageV.frame = FRAME(100, 5, 30, 30);
    imageV.image = [UIImage imageNamed:@"update"];
    [bj_view addSubview:imageV];
    //设置确定按钮
    btn_true.frame = FRAME(WIDTH - 110, 100, 60, 30);
    [btn_true setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [btn_true setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    btn_true.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn_true addTarget:self action:@selector(clickToTrue) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn_true];
    //设置取消按钮
    btn_cancel.frame = FRAME(WIDTH - 180, 100, 60, 30);
    [btn_cancel setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [btn_cancel setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    btn_cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn_cancel addTarget:self action:@selector(clickToCancel) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn_cancel];
    //设置一个显示验证码错误的label
    label_error.frame = FRAME(10, 100, 120, 20);
    label_error.text = NSLocalizedString(@"输入有误,请重新输入", nil);
    label_error.textColor = [UIColor redColor];
    label_error.font = [UIFont systemFontOfSize:12.5];
    label_error.hidden = YES;
    [view addSubview:label_error];
    [self setBlock:^(NSString * result,NSString * code) {
        myBlock(result,code);
    }];

}
#pragma mark - 这是点击图片切换手势的方法
-(void)clickToUpData{
    NSLog(@"你点击了图片切换的方法");
    NSString * mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"SECURITY_MOBILE"];
    NSDictionary *dic = @{@"mobile":mobile};
    //获取图形验证码
    [HttpTool postWithAPI:@"magic/verify" withParams:dic success:^(id json) {
        
        if(json){
            displayImageView.image  = json;
        }else{
            [self  showAlertViewWithTitle:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
        }
    } failure:^(NSError *error) {
        [self showAlertViewWithTitle:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
-(void)refesh:(UIImage *)image{
    displayImageView.image = image;
}
#pragma mark - 这是点击确定的方法
-(void)clickToTrue{
    NSLog(@"%@",[myTextField.text lowercaseString]);
    [self endEditing:YES];
    if (myTextField.text.length == 0) {
        label_error.hidden = NO;
        myTextField.text = @"";
        [self clickToUpData];
        return;
    }
    btn_true.userInteractionEnabled = NO;
    NSString * mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"SECURITY_MOBILE"];
    NSDictionary *dic = @{@"mobile":mobile,@"img_code":myTextField.text};
    [HttpTool postWithAPI:@"magic/sendsms" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        btn_true.userInteractionEnabled = YES;
        if ([json[@"error"] isEqualToString:@"0"]) {
            self.block(@"正确",nil);
        }else{
            [self clickToUpData];
            [self clickToCancel];
            label_error.hidden = NO;
            myTextField.text = @"";
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"图形验证错误,请重试!", nil)];
        }
    } failure:^(NSError *error) {
        btn_true.userInteractionEnabled = YES;
        [self showAlertViewWithTitle:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是点击取消按钮的方法
-(void)clickToCancel{
    NSLog(@"点击了取消");
    [self endEditing:YES];
    self.block(NSLocalizedString(@"取消", nil),nil);
}
#pragma mark - 这是点击获取验证码的背景
-(void)Cancel{
    if (![myTextField isFirstResponder]) {
        self.block(@"取消",nil);
    }else{
        [self endEditing:YES];
    }
}
#pragma mark - 这是警告框的代理和数据源方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    label_error.hidden = YES;
}
- (void)showAlertViewWithTitle:(NSString *)title{
    UIAlertController * alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:alertViewController animated:YES completion:nil];
}
@end
