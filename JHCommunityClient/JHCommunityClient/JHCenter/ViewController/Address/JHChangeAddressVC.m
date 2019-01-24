//
//  JHChangeAddressVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//修改地址

#import "JHChangeAddressVC.h"
#import "OptionBnt.h"
 
#import "XHCodeTF.h"
@interface JHChangeAddressVC ()<UITextFieldDelegate>
{
    UITextField *_name;//姓名
    XHCodeTF *_phone;//电话
    UITextField *_address;//地址
    UITextField *_addressDetail;//具体地址
    UIControl *_backView;//背景
    UIButton *_lastBnt;
}
@end

@implementation JHChangeAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"修改地址", nil);
    self.view.backgroundColor = BACK_COLOR;
    UIButton *deleteBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBnt.frame = FRAME(0, 0, 15, 15);
    [deleteBnt setBackgroundImage:IMAGE(@"laji") forState:UIControlStateNormal];
    [deleteBnt addTarget:self action:@selector(deleteBnt) forControlEvents:UIControlEventTouchUpInside];
    deleteBnt.titleLabel.font = FONT(14);
    [deleteBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBnt];
    self.navigationItem.rightBarButtonItem = rightItem;
    _lastBnt = nil;
    [self createUI];
}
#pragma mark=========搭建UI界面===========
- (void)createUI
{
    _name = [[UITextField alloc] initWithFrame:FRAME(75, 0, WIDTH - 75, 40)];
    _name.font = FONT(14);
    _name.placeholder = NSLocalizedString(@"请输入姓名", nil);
    _name.delegate = self;
    if(self.nameText.length != 0)
    {
        _name.text = self.nameText;
    }
    _phone = [[XHCodeTF alloc] initWithFrame:FRAME(75, 0, WIDTH - 75, 40)];
    _phone.font = FONT(14);
    _phone.placeholder = NSLocalizedString(@"请输入手机号码", nil);
    _phone.delegate = self;
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    if(self.mobile.length != 0)
    {
        _phone.text = self.mobile;
    }
    _phone.showCode = SHOW_COUNTRY_CODE;
    __weak typeof(self)weakself = self;
    _phone.fatherVC = weakself;
    
    _address = [[UITextField alloc] initWithFrame:FRAME(70, 0, WIDTH - 110, 40)];
    _address.font = FONT(14);
    _address.delegate = self;
    _address.userInteractionEnabled = NO;
    if(self.addr.length != 0)
    {
        _address.text = self.addr;
    }
    _addressDetail = [[UITextField alloc] initWithFrame:FRAME(75, 0, WIDTH - 75, 40)];
    _addressDetail.font = FONT(14);
    _addressDetail.placeholder = NSLocalizedString(@"请输入门牌号的具体信息", nil);
    _addressDetail.delegate = self;
    if(self.addrDetail.length != 0)
    {
        _addressDetail.text = self.addrDetail;
    }
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
        if (optionBnt.tag == [_bntTag integerValue]) {
            optionBnt.selected = YES;
            _lastBnt = optionBnt;
        }
    }
    UIButton *changeAddressBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    changeAddressBnt.frame = FRAME(10, 250, WIDTH - 20, 40);
    [changeAddressBnt setTitle:NSLocalizedString(@"确认修改", nil) forState:UIControlStateNormal];
    [changeAddressBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeAddressBnt.layer.cornerRadius = 4.0f;
    changeAddressBnt.clipsToBounds = YES;
    changeAddressBnt.titleLabel.font = FONT(14);
    [changeAddressBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [changeAddressBnt setBackgroundColor:HEX(@"59C181", 0.6f) forState:UIControlStateHighlighted];
    [changeAddressBnt addTarget:self action:@selector(changeAddressBnt) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:changeAddressBnt];
}
#pragma mark==========确认添加地址===========
- (void)changeAddressBnt
{
    NSLog(@"确认修改地址");
    if(_name.text.length == 0 || _phone.text.length == 0 || _address.text.length == 0 || _addressDetail.text.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"亲,请完善相关信息哦", nil)];
    }
    if(_name.text.length > 0 && _phone.text.length > 0 && _addressDetail.text.length > 0 && _address.text.length > 0)
    {
        SHOW_HUD
        NSDictionary *dic = @{@"addr_id":self.addr_id,@"contact":_name.text,@"mobile":_phone.text,@"addr":_address.text,@"house":_addressDetail.text,@"lat":self.lat,@"lng":self.lng,@"type":_bntTag};
        NSLog(@"%@",dic);
        NSLog(@"%@",self.bntTag);
        [HttpTool postWithAPI:@"client/member/addr/update" withParams:dic success:^(id json) {
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
                [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"修改地址失败,原因:%@", nil),json[@"message"]]];
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
    NSLog(@"选择啦%ld",(long)sender.tag);
    self.bntTag = [NSString stringWithFormat:@"%ld",(long)sender.tag];
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
        self.lat = @(place.coordinate.latitude).description;
        self.lng = @(place.coordinate.longitude).description;
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
#pragma mark============删除按钮点击事件==========
- (void)deleteBnt
{
    NSLog(@"删除地址");
    NSDictionary *dic = @{@"addr_id":self.addr_id};
    [HttpTool postWithAPI:@"client/member/addr/delete" withParams:dic success:^(id json) {
        if([json[@"error"] isEqualToString:@"0"])
        {
            [self.navigationController popViewControllerAnimated:YES];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAddr" object:nil];
        }
        else
        {
            [self showAlertView:[NSString stringWithFormat:NSLocalizedString(@"地址删除失败,%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertView:error.localizedDescription];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
