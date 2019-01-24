//
//  ChangeNameVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/2/27.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHChangeNameVC.h"
 
@interface JHChangeNameVC ()<UITextFieldDelegate>
{
    UITextField *_name;
    UIButton *_certainBnt;
}
@end

@implementation JHChangeNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"修改昵称", nil);
    self.view.backgroundColor = BACK_COLOR;
    [self createUI];
}
#pragma mark=====搭建UI界面====
- (void)createUI{
    UIControl *backView = [[UIControl alloc] initWithFrame:FRAME(0, NAVI_HEIGHT+10, WIDTH, 50)];
    [backView addTarget:self action:@selector(touch_BackView) forControlEvents:UIControlEventTouchUpInside];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 49.5, WIDTH, 0.5)];
    thread1.backgroundColor = LINE_COLOR;
    [backView addSubview:thread1];
    UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 1)];
    thread2.backgroundColor = LINE_COLOR;
    [backView addSubview:thread2];
    _name =[[UITextField alloc] initWithFrame:FRAME(10, 1, WIDTH, 48.5)];
    _name.placeholder = NSLocalizedString(@"请输入姓名", nil);
    _name.font = FONT(14);
    _name.textColor = HEX(@"999999", 1.0f);
    _name.delegate = self;
    if(_nick_name.length != 0 && _nick_name != nil)
        _name.text = _nick_name;
    [backView addSubview:_name];
    _certainBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _certainBnt.frame = FRAME(10, 100+NAVI_HEIGHT, WIDTH - 20, 44);
    [_certainBnt setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [_certainBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _certainBnt.layer.cornerRadius = 2.0f;
    _certainBnt.clipsToBounds = YES;
    _certainBnt.titleLabel.font = FONT(14);
    [_certainBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [_certainBnt setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
    [_certainBnt addTarget:self action:@selector(certainBnt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_certainBnt];
}
#pragma  mark========退出键盘============
- (void)touch_BackView
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark========确定按钮点击事件============
- (void)certainBnt
{
    NSLog(@"确定");
    if(_name.text.length < 2)
    {
        [self showAlertView:NSLocalizedString(@"请输入不少于2个字的昵称", nil)];
    }
    else
    {
        NSDictionary *dic = @{@"nickname":_name.text};
        [HttpTool postWithAPI:@"client/v3/member/member/updatename" withParams:dic success:^(id json) {
            if([json[@"error"] isEqualToString:@"0"])
            {
                _certainBnt.hidden = YES;
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeName" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:_name.text forKey:@"nickName"];
            }else{
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"修改昵称失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertView:error.localizedDescription];
        }];
    }
}
#pragma mark=======提示框===========
- (void)showAlertView:(NSString *)title{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
@end
