//
//  JHIntegrationCancelMengBan.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//积分商城订单取消蒙版

#import "JHIntegrationCancelMengBan.h"
#import "AppDelegate.h"
 
@implementation JHIntegrationCancelMengBan
{
    UITextView *_cancelText;//取消理由
    UIView  *_cancelBackView;//取消订单蒙版白色视图
    UILabel *_describleLabel;//请输入你想回复的内容标签
    UILabel *_numLabel;//字数标签
     NSString *_reason;//取消订单理由
    UIButton *_lastBnt;
}

+(void)createIntegrationMengBanWithOrder_id:(NSString *)order_id cancelSuccess:(void (^)())cancelSuccessBlock{
    JHIntegrationCancelMengBan *mengBan = [[JHIntegrationCancelMengBan alloc] init];
    mengBan.order_id = order_id;
    mengBan.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    mengBan.frame = FRAME(0, 0,WIDTH,HEIGHT);
    [mengBan createIntegrationMengBan:mengBan];
    [mengBan setCancelSuccessBlock:^{
        cancelSuccessBlock();
    }];
}
- (void)createIntegrationMengBan:(JHIntegrationCancelMengBan *)mengBan{
    _cancelMengBan = mengBan;
    [_cancelMengBan addTarget:self action:@selector(touchView) forControlEvents:UIControlEventTouchUpInside];
    AppDelegate *delegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_cancelMengBan];
    _cancelBackView = [[UIView alloc] initWithFrame:FRAME(27.5, (HEIGHT  - 300) / 2, WIDTH - 55, 300)];
    _cancelBackView.backgroundColor = [UIColor whiteColor];
    _cancelBackView.layer.cornerRadius = 4.0f;
    _cancelBackView.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canceltextView)];
    _cancelBackView.userInteractionEnabled = YES;
    [_cancelBackView addGestureRecognizer:tap];
    [_cancelMengBan addSubview:_cancelBackView];
    UILabel *title = [[UILabel alloc] initWithFrame:FRAME(0, 0, _cancelBackView.bounds.size.width, 40)];
    title.font = FONT(14);
    title.textColor = HEX(@"333333", 1.0f);
    title.text = NSLocalizedString(@"取消理由", nil);
    title.textAlignment = NSTextAlignmentCenter;
    [_cancelBackView addSubview:title];
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, _cancelBackView.bounds.size.width, 0.5)];
    thread.backgroundColor = LINE_COLOR;
    [_cancelBackView addSubview:thread];
    NSArray *titleArray = @[NSLocalizedString(@"临时有事", nil),NSLocalizedString(@"想换个商品", nil),NSLocalizedString(@"信息填错", nil),NSLocalizedString(@"不想买了", nil),NSLocalizedString(@"付不了款", nil),NSLocalizedString(@"其他", nil)];
    CGFloat space = (_cancelBackView.bounds.size.width - 240)/4;
    for(int i = 0 ; i < 6; i ++){
        UIButton *bnt = [UIButton buttonWithType:UIButtonTypeCustom];
        bnt.frame = FRAME(space + (80 + space) * (i % 3), (i / 3) * 45 + 55, 80, 30);
        [bnt setTitleColor:THEME_COLOR forState:UIControlStateHighlighted];
        [bnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [bnt setTitleColor:HEX(@"666666", 1.0f) forState:UIControlStateNormal];
        bnt.layer.cornerRadius = 15.0f;
        bnt.layer.borderColor = LINE_COLOR.CGColor;
        bnt.layer.borderWidth = 0.5f;
        bnt.clipsToBounds = YES;
        bnt.tag = i + 1;
        bnt.titleLabel.font = FONT(12);
        [bnt setTitle:titleArray[i] forState:UIControlStateNormal];
        if(i == 0){
            bnt.selected = YES;
            [bnt setTitle:NSLocalizedString(@"临时有事", nil) forState:UIControlStateNormal];
            _reason = bnt.currentTitle;
            _lastBnt = bnt;
        }
        [bnt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBackView addSubview:bnt];
    }
    UIView *textBackView = [[UIView alloc] initWithFrame:FRAME(15, 95 + 45, _cancelBackView.bounds.size.width - 30, 90)];
    textBackView.backgroundColor = HEX(@"fafafa", 1.0f);
    [_cancelBackView addSubview:textBackView];
    _cancelText = [[UITextView alloc] initWithFrame:FRAME(10, 0, textBackView.bounds.size.width - 20, 80 - 15)];
    _cancelText.delegate = self;
    _cancelText.font = FONT(12);
    _cancelText.backgroundColor = HEX(@"fafafa", 1.0f);
    [textBackView addSubview:_cancelText];
    _describleLabel = [[UILabel alloc] initWithFrame:FRAME(0, 10, _cancelText.bounds.size.width - 20, 15)];
    _describleLabel.font = FONT(12);
    _describleLabel.textColor = HEX(@"cccccc", 1.0f);
    _describleLabel.text = NSLocalizedString(@"补充说明", nil);
    [_cancelText addSubview:_describleLabel];
    _numLabel = [[UILabel alloc] initWithFrame:FRAME(textBackView.bounds.size.width - 140,textBackView.bounds.size.height - 15, 130, 15)];
    _numLabel.text = NSLocalizedString(@"120字", nil);
    _numLabel.font = FONT(12);
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.textColor = HEX(@"cccccc", 1.0f);
    [textBackView addSubview:_numLabel];
    CGFloat bntSpace = (_cancelBackView.bounds.size.width - 160) / 3;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = FRAME(bntSpace, 245, 80, 40);
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT(16);
    [cancelBtn setBackgroundColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = 4.0f;
    cancelBtn.clipsToBounds = YES;
    [_cancelBackView addSubview:cancelBtn];
    UIButton *certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    certainBtn.frame = FRAME(2 * bntSpace + 80, 245, 80, 40);
    [certainBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    certainBtn.titleLabel.font = FONT(16);
    [certainBtn setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [certainBtn addTarget:self action:@selector(certainButton) forControlEvents:UIControlEventTouchUpInside];
    certainBtn.layer.cornerRadius = 4.0f;
    certainBtn.clipsToBounds = YES;
    [_cancelBackView addSubview:certainBtn];
}
#pragma mark--=======蒙版上取消按钮点击事件=====
- (void)cancelButton{
    [_cancelMengBan removeFromSuperview];
    _cancelMengBan = nil;
}
#pragma mark=======蒙版上确定按钮点击事件==========
- (void)certainButton{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:_cancelBackView animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString *reason = nil;
    if(_cancelText.text.length == 0){
        reason = _reason;
    }else{
        reason = [NSString stringWithFormat:NSLocalizedString(@"%@,补充:%@", nil),_reason,_cancelText.text];
    }
    NSDictionary *dic = @{@"order_id":self.order_id,@"reason":reason};
    NSString *api = @"client/mall/order/cancel";
    [HttpTool postWithAPI:api withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        [MBProgressHUD hideHUDForView:_cancelBackView animated:YES];
        if([json[@"error"] isEqualToString:@"0"]){
            [_cancelMengBan removeFromSuperview];
            _cancelMengBan = nil;
            if(self.cancelSuccessBlock){
                self.cancelSuccessBlock();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrder" object:nil];
        }else{
            [_cancelMengBan removeFromSuperview];
            _cancelMengBan = nil;
            [MBProgressHUD hideHUDForView:_cancelBackView animated:YES];
            [self showAlert:[NSString stringWithFormat:NSLocalizedString(@"取消订单失败 ,原因%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        [_cancelMengBan removeFromSuperview];
        _cancelMengBan = nil;
        [MBProgressHUD hideHUDForView:_cancelBackView animated:YES];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlert:error.localizedDescription];
        
    }];
}
- (void)touchView{
    [_cancelMengBan  removeFromSuperview];
    _cancelMengBan = nil;
}
#pragma mark========取消订单理由上面蒙版白色视图的轻点手势事件============
- (void)canceltextView{
    [_cancelText resignFirstResponder];
}
#pragma mark-=====
#pragma mark========取消理由蒙版理由按钮点击事件========
- (void)clickButton:(UIButton *)sender{
    if(_lastBnt != nil){
        _lastBnt.selected = NO;
        _lastBnt.layer.borderColor = LINE_COLOR.CGColor;
    }
    sender.selected = YES;
    sender.layer.borderColor  = THEME_COLOR.CGColor;
    _lastBnt = sender;
    _reason = sender.currentTitle;
}

#pragma mark=======UITextViewDelegate=======
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _describleLabel.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = _cancelBackView.frame;
        rect.origin.y = 40;
        _cancelBackView.frame = rect;
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if(_cancelText.text.length == 0){
        _describleLabel.hidden = NO;
        _numLabel.text = NSLocalizedString(@"120字", nil);
    }else if (_cancelText.text.length < 120 && _cancelText.text.length > 0){
        NSInteger num = 120 - (_cancelText.text.length);
        _numLabel.text = [NSString stringWithFormat:NSLocalizedString(@"可输入%ld字", nil),(long)num];
    }else{
        _numLabel.text = NSLocalizedString(@"不能再输入喽", nil);
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = _cancelBackView.frame;
        rect.origin.y = (HEIGHT  - 255) / 2;
        _cancelBackView.frame = rect;
    }];
}
- (void)textViewDidChange:(UITextView *)textView{
    if(_cancelText.text.length >= 120){
        [self textViewShouldEndEditing:_cancelText];
        [_cancelText resignFirstResponder];
        _numLabel.text = NSLocalizedString(@"不能再输入喽", nil);
    }else{
        NSInteger num = 120 - (_cancelText.text.length);
        _numLabel.text = [NSString stringWithFormat:NSLocalizedString(@"可输入%ld字", nil),(long)num];
    }
}
#pragma mark-======显示警告框=====
- (void)showAlert:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    AppDelegate *delegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end
