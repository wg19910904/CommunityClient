//
//  AddAddressVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//添加地址

#import "JHAddAddressVC.h"
#import "OptionBnt.h"
 
#import "MBProgressHUD.h"
#import "XHCodeTF.h"
@interface JHAddAddressVC ()<UITextFieldDelegate>
{
    UITextField *_name;//姓名
    XHCodeTF *_phone;//电话
    UITextField *_address;//地址
    UITextField *_addressDetail;//具体地址
    UIControl *_backView;//背景
    UIButton *_lastBnt;
    NSString * _bntTag;
}

@end

@implementation JHAddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"添加地址", nil);
    _bntTag = @"0";
    self.view.backgroundColor = BACK_COLOR;
    [self createUI];
}
#pragma mark=========搭建UI界面===========
- (void)createUI
{
    _name = [[UITextField alloc] initWithFrame:FRAME(75, 0, WIDTH - 75, 40)];
    _name.font = FONT(14);
    _name.placeholder = NSLocalizedString(@"请输入姓名", nil);
    _name.delegate = self;
    _phone = [[XHCodeTF alloc] initWithFrame:FRAME(75, 0, WIDTH - 75, 40)];
    _phone.font = FONT(14);
    _phone.placeholder = NSLocalizedString(@"请输入手机号码", nil);
    _phone.delegate = self;
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    _phone.showCode = SHOW_COUNTRY_CODE;
    __weak typeof(self)weakself = self;
    _phone.fatherVC = weakself;
    
    _address = [[UITextField alloc] initWithFrame:FRAME(70, 0, WIDTH - 110, 40)];
    _address.font = FONT(14);
    _address.delegate = self;
    _address.userInteractionEnabled = NO;
    _addressDetail = [[UITextField alloc] initWithFrame:FRAME(75, 0, WIDTH - 75, 40)];
    _addressDetail.font = FONT(14);
    _addressDetail.placeholder = NSLocalizedString(@"请输入门牌号的具体信息", nil);
    _addressDetail.delegate = self;
    _backView = [[UIControl alloc] initWithFrame:FRAME(0, (NAVI_HEIGHT+10), WIDTH, HEIGHT - (NAVI_HEIGHT+10))];
    _backView.backgroundColor = BACK_COLOR;
    [_backView addTarget:self action:@selector(touch_BackView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backView];
    for(int i = 0 ; i < 4; i ++)
    {
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, i * 50, WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:view];
        UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread1.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [view addSubview:thread1];
        UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
        thread2.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [view addSubview:thread2];
        UIView *thread3 = [[UIView alloc] initWithFrame:FRAME(61, 5, 1, 30)];
        thread3.backgroundColor = HEX(@"E6E6E6", 1.0f);
        [view addSubview:thread3];
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 60, 40)];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(14);
        [view addSubview:label];
        if(i == 0)
        {
            label.text = NSLocalizedString(@"姓  名", nil);
            [view addSubview:_name];
        }
        else if(i == 1)
        {
            label.text = NSLocalizedString(@"电  话", nil);
            [view addSubview:_phone];
        }
        else if(i == 2)
        {
            label.text = NSLocalizedString(@"地  址", nil);
            [view addSubview:_address];
            UIButton *locationBnt = [UIButton buttonWithType:UIButtonTypeCustom];
            locationBnt.frame = FRAME(70, 10, WIDTH - 70, 20);
            [locationBnt setImage:IMAGE(@"dizhi") forState:UIControlStateNormal];
            [locationBnt setImageEdgeInsets:UIEdgeInsetsMake(0, WIDTH - 100, 0, 10)];
            [locationBnt addTarget:self action:@selector(locationBnt) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:locationBnt];
        }
        else
        {
            label.text = NSLocalizedString(@"门牌号", nil);
            [view addSubview:_addressDetail];
        }
    }
    UILabel *optionLabel = [[UILabel alloc] initWithFrame:FRAME(10, 205, 55, 10)];
    optionLabel.textColor = HEX(@"999999", 1.0f);
    optionLabel.textAlignment = NSTextAlignmentLeft;
    optionLabel.font = FONT(12);
    optionLabel.text = NSLocalizedString(@"标签", nil);
    [_backView addSubview:optionLabel];
    for(int i = 0; i< 4; i ++)
    {
        OptionBnt *optionBnt = [[OptionBnt alloc] init];
        optionBnt.frame = FRAME(70 + i*60 , 200, 50, 20);
        [optionBnt addTarget:self action:@selector(optionBnt:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:optionBnt];
        optionBnt.tag = i + 1;
        [optionBnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        optionBnt.titleLabel.font = FONT(14);
        [optionBnt setImage:IMAGE(@"selectDefault") forState:UIControlStateNormal];
        [optionBnt setImage:IMAGE(@"selectCurrent") forState:UIControlStateSelected];
        if(i == 0)
        {
            [optionBnt setTitle:NSLocalizedString(@"公司", nil) forState:UIControlStateNormal];
        }
        else if(i == 1)
        {
            [optionBnt setTitle:NSLocalizedString(@"家", nil) forState:UIControlStateNormal];
        }
        else if(i == 2)
        {
            [optionBnt setTitle:NSLocalizedString(@"学校", nil) forState:UIControlStateNormal];
        }
        else
        {
            [optionBnt setTitle:NSLocalizedString(@"其他", nil) forState:UIControlStateNormal];
        }
    }
    _lastBnt = nil;
    UIButton *addAddressBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBnt.frame = FRAME(10, 250, WIDTH - 20, 40);
    [addAddressBnt setTitle:NSLocalizedString(@"确认添加", nil) forState:UIControlStateNormal];
    [addAddressBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addAddressBnt.layer.cornerRadius = 4.0f;
    addAddressBnt.clipsToBounds = YES;
    addAddressBnt.titleLabel.font = FONT(14);
    [addAddressBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [addAddressBnt setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
    [addAddressBnt addTarget:self action:@selector(addAddressBnt) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:addAddressBnt];
}
#pragma mark==========确认添加地址===========
- (void)addAddressBnt
{
    NSLog(@"确认添加地址");
    if(_name.text.length == 0 || _phone.text.length == 0 || _address.text.length == 0 || _addressDetail.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"亲,请完善相关信息哦", nil)];
    }
    if(_name.text.length > 0 && _phone.text.length > 0 && _addressDetail.text.length > 0 && _address.text.length > 0)
    {
        SHOW_HUD
        NSDictionary *dic = @{@"contact":_name.text,@"mobile":_phone.text,@"addr":_address.text,@"house":_addressDetail.text,@"lat":self.lat,@"lng":self.lng,@"type":_bntTag};
        NSLog(@"%@",_bntTag);
        [HttpTool postWithAPI:@"client/member/addr/create" withParams:dic success:^(id json) {
            NSLog(@"%@",json);
            if([json[@"error"] isEqualToString:@"0"])
            {
                HIDE_HUD
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAddr" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                HIDE_HUD
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"添加地址失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertView:error.localizedDescription];
        }];
    }
    
    
}
#pragma mark=====非必填选项按钮点击事件===============
- (void)optionBnt:(UIButton *)sender
{
    _bntTag = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    NSLog(@"选择啦%ld",(long)sender.tag);
    if(_lastBnt != nil)
    {
        _lastBnt.selected = NO;
    }
    sender.selected = YES;
    _lastBnt = sender;
    
}
#pragma mark========定位按钮点击事件===========
- (void)locationBnt
{
    NSLog(@"定位啦");
    XHPlacePicker *placePicker = [[XHPlacePicker alloc] initWithPlaceCallback:^(XHLocationInfo *place) {
        _address.text = place.address;
        self.lat = @(place.bdCoordinate.latitude).description;
        self.lng = @(place.bdCoordinate.longitude).description;
    }];
    [placePicker startPlacePicker];
}
#pragma mark==========键盘退出===============
- (void)touch_BackView
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark========当开始编辑键盘弹出时将组件向上移=======
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = _backView.frame;
        rect.origin.y -= 10;
        _backView.frame = rect;
    }];
}
#pragma mark ======当结束编辑时将组件的frame还原=======
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 animations:^{
        _backView.frame=CGRectMake(0, (NAVI_HEIGHT+10), WIDTH, HEIGHT);
    }];
}

#pragma mark======提示框=========
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
