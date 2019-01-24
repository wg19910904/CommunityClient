//
//  JHFeedBackVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//意见反馈

#import "JHFeedBackVC.h"
#import "NSObject+CGSize.h"
 
#import "MBProgressHUD.h"
@interface JHFeedBackVC ()<UITextViewDelegate>
{
    UITextView *_textView;
    UILabel *_describelLabel;
    UIButton *_tipBnt;
    
}
@end

@implementation JHFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"意见反馈", nil);
    self.view.backgroundColor = BACK_COLOR;
    [self createUI];
}
#pragma  mark========搭建UI界面===========
- (void)createUI
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.font = FONT(14);
    label.text = NSLocalizedString(@"如果您在使用app的过程中遇到任何问题,请留下你的宝贵意见给我们的产品经理,我们会竭尽全力做出更优秀的产品供您使用", nil);
    CGSize size = [self currentSizeWithString:label.text font:FONT(14) withWidth:20];
    label.frame = FRAME(10, (NAVI_HEIGHT+10), size.width, size.height);
    label.numberOfLines = 0;
    [self.view addSubview:label];
    _textView = [[UITextView alloc] initWithFrame:FRAME(10, 84-20+STATUS_HEIGHT + size.height, WIDTH - 20, 150)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.borderColor = HEX(@"E6E6E6", 1.0f).CGColor;
    _textView.delegate = self;
    _textView.font = FONT(14);
    _textView.editable = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenDescribel) name:UITextViewTextDidBeginEditingNotification object:nil];
    [self.view addSubview:_textView];
     _describelLabel = [[UILabel alloc] initWithFrame:FRAME(10, 10, 200, 10)];
     _describelLabel.text = NSLocalizedString(@"请输入至少15个字的意见反馈", nil);
     _describelLabel.textColor = HEX(@"999999", 1.0f);
     _describelLabel.font = FONT(12);
     [_textView addSubview:_describelLabel];
    _tipBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _tipBnt.frame = FRAME(10, 94-20+STATUS_HEIGHT + size.height + 150 + 30, WIDTH - 20, 40);
    [_tipBnt setTitle:NSLocalizedString(@"确认提交",nil)  forState:UIControlStateNormal];
    [_tipBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tipBnt.layer.cornerRadius = 4.0f;
    _tipBnt.clipsToBounds = YES;
    _tipBnt.titleLabel.font = FONT(14);
    [_tipBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [_tipBnt setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
    [_tipBnt addTarget:self action:@selector(tipBnt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tipBnt];
}
#pragma mark============确认提交按钮点击事件============
- (void)tipBnt
{
    NSLog(@"提交意见反馈");
    if(_textView.text.length < 15)
    {
        [self showAlertView:NSLocalizedString(@"意见字数能不少于15字", nil)];
    }
    else
    {
        SHOW_HUD
        NSDictionary *dic = @{@"content":_textView.text};
        [HttpTool postWithAPI:@"client/member/feedback" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"])
            {
                HIDE_HUD
                //[self.navigationController popViewControllerAnimated:YES];
                _textView.text = nil;
                _tipBnt.userInteractionEnabled = NO;
                [_tipBnt setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(600 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _tipBnt.userInteractionEnabled = YES;
                    [_tipBnt setBackgroundColor:HEX(@"59C181", 1.0f) forState:UIControlStateNormal];
                });
                [self showAlertView:NSLocalizedString(@"提交反馈成功,十分钟以后可再次提交,感谢您的支持", nil)];
            }
            else
            {
                HIDE_HUD
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"意见提交失败,%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertView:error.localizedDescription];
        }];
    }
}
#pragma mark==========隐藏DescribelLabel===========
- (void)hiddenDescribel
{
    _describelLabel.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [_textView resignFirstResponder];
}
#pragma mark==========退出键盘===============
- (void)touch_BackView
{
    [self.view endEditing:YES];
    if(_textView.text.length == 0)
    {
       _describelLabel.hidden = NO;
    }

}
#pragma mark======提示框=========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
@end
