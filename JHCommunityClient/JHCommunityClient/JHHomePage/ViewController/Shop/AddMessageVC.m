//
//  AddMessageVC.m
//  Lunch
//
//  Created by jianghu1 on 15/12/17.
//  Copyright © 2015年 jianghu. All rights reserved.
//

#import "AddMessageVC.h"
 
@interface AddMessageVC ()<UITextViewDelegate>
{
    //创建textView
    UITextView *_textView;
    NSArray *_infoArr;//存储获取的备注数组
}

@end

@implementation AddMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加左按钮
    [self createLeftBtn];
    self.title = NSLocalizedString(@"添加备注", nil);
    self.view.backgroundColor = BACK_COLOR;
    
    [self createMessageView];
    [self createSureBtn];
    [self createMsglabel];
//    [self getInfo];
}

#pragma mark - 创建左边按钮
- (void)createLeftBtn
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 9, 15)];
    [leftBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

#pragma mark - 添加备注框
- (void)createMessageView
{
    //创建背景框
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, 130)];
    backView.backgroundColor = [UIColor whiteColor];
    //添加下边线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 129.5, WIDTH, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    
    //添加备注视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, WIDTH - 30, 120)];
    if ([_msgString isEqualToString:NSLocalizedString(@"添加备注", nil)]) {
         _textView.text = NSLocalizedString(@"输入您想交代的话吧", nil);
    }else{
        _textView.text = _msgString;
    }
    
    _textView.backgroundColor = BACK_COLOR;
    _textView.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    _textView.delegate = self;
    _textView.layer.cornerRadius = 4;
    _textView.layer.masksToBounds = YES;
    _textView.layer.borderColor = LINE_COLOR.CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.font = [UIFont systemFontOfSize:15];
    [backView addSubview:_textView];
    [backView addSubview:lineView];
    [self.view addSubview:backView];

}

#pragma mark - 添加确定按钮
- (void)createSureBtn
{
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 240-64+NAVI_HEIGHT, WIDTH - 30, 45)];
    [sureBtn setTitle:NSLocalizedString(@"确定", nil)   forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:THEME_COLOR];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    //添加方法方法
    [sureBtn addTarget:self action:@selector(clickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    

}
- (void)getInfo{
//    SHOW_HUD
//    [HttpTool postWithAPI:@"client/waimai/order/remark"
//               withParams:@{}
//                  success:^(id json) {
//                      HIDE_HUD
//                      NSLog(@"%@",json);
//                      if ([json[@"error"] isEqualToString:@""]) {
//
//                      }
//                  } failure:^(NSError *error) {
//                      HIDE_HUD
//                  }];
}
#pragma mark - 添加备注标签
- (void)createMsglabel
{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 200-64+NAVI_HEIGHT, 85, 20)];
    timeLabel.text = NSLocalizedString(@"30分钟内送达", nil);
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    timeLabel.layer.borderWidth = 0.5;
    timeLabel.layer.borderColor = LINE_COLOR.CGColor;
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(gesture1:)];
    [timeLabel addGestureRecognizer:gesture1];

    
    UILabel *kouweiLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 200-64+NAVI_HEIGHT, 85, 20)];
    kouweiLabel.text = NSLocalizedString(@"口味要清淡的", nil);
    kouweiLabel.font = [UIFont systemFontOfSize:12];
    kouweiLabel.textColor = THEME_COLOR;
    kouweiLabel.layer.borderWidth = 0.5;
    kouweiLabel.layer.borderColor = THEME_COLOR.CGColor;
    kouweiLabel.backgroundColor = [UIColor whiteColor];
    kouweiLabel.textAlignment = NSTextAlignmentCenter;
    kouweiLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(gesture2:)];
    [kouweiLabel addGestureRecognizer:gesture2];
    
    
    UILabel *laLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 200-64+NAVI_HEIGHT, 55, 20)];
    laLabel.text = NSLocalizedString(@"少放辣的", nil);
    laLabel.font = [UIFont systemFontOfSize:12];
    laLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    laLabel.layer.borderWidth = 0.5; 
    laLabel.layer.borderColor = LINE_COLOR.CGColor;
    laLabel.backgroundColor = [UIColor whiteColor];
    laLabel.textAlignment = NSTextAlignmentCenter;
    laLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(gesture3:)];
    [laLabel addGestureRecognizer:gesture3];
    
    [self.view addSubview:timeLabel];
    [self.view addSubview:kouweiLabel];
    [self.view addSubview:laLabel];
}
#pragma mark - delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //判断文本内容是否需要消除
    if ([textView.text isEqualToString:NSLocalizedString(@"输入您想交代的话吧", nil)]) {
        textView.text = @"";
    }else{
        
        //do nothing
    }
    return YES;
}
#pragma mark - 点击手势按钮
- (void)gesture1:(UITapGestureRecognizer *)gesture
{
    //更改textView的值
    [self textViewShouldBeginEditing:_textView];
    _textView.text = [_textView.text stringByAppendingString:NSLocalizedString(@"30分钟内送达", nil)];
    [_textView becomeFirstResponder];
}
- (void)gesture2:(UITapGestureRecognizer *)gesture
{
    //更改textView的值
    [self textViewShouldBeginEditing:_textView];
    _textView.text = [_textView.text stringByAppendingString:NSLocalizedString(@"口味要清淡的", nil)];
    [_textView becomeFirstResponder];
}
- (void)gesture3:(UITapGestureRecognizer *)gesture
{
    //更改textView的值
    [self textViewShouldBeginEditing:_textView];
    _textView.text = [_textView.text stringByAppendingString:NSLocalizedString(@"少放辣的", nil)];
    [_textView becomeFirstResponder];
    
}
#pragma mark - 点击确定按钮
- (void)clickSureBtn:(UIButton *)sender
{
    self.block(_textView.text);
    [self clickBackBtn];
}


#pragma mark - 点击返回按钮
- (void)clickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
