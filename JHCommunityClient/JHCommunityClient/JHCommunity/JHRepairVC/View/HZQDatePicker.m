//
//  HZQDatePicker.m
//  时间选择器
//
//  Created by ijianghu on 16/8/3.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "HZQDatePicker.h"
#import "HZQChangeDateLine.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation HZQDatePicker{
    HZQDatePicker * _datePicker;
    UIView * view_bj;
    NSString * time;
    NSDate * _selecterDate;
}
-(void)creatDatePickerWithObj:(HZQDatePicker *)datePicker withDate:(NSDate *)selecterDate{
    if (selecterDate == nil) {
        selecterDate = [NSDate date];
    }
    _selecterDate = selecterDate;
    datePicker.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    datePicker.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    [window addSubview:datePicker];
    _datePicker = datePicker;
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToCancle)];
    [datePicker addGestureRecognizer:tapGestureRecognizer];
    if (view_bj == nil) {
        //创建白色的背景层
        view_bj = [[UIView alloc]init];
        view_bj.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        view_bj.backgroundColor = [UIColor whiteColor];
        view_bj.layer.cornerRadius = 4;
        view_bj.clipsToBounds  = YES;
        [datePicker addSubview:view_bj];
        //创建一层灰色的
        UIView * view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [view_bj addSubview:view];
        //创建取消和确定的按钮
        UIButton * btn_cancel = [[UIButton alloc]init];
        btn_cancel.frame = CGRectMake(0, 0, 60, 40);
        [btn_cancel setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [btn_cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn_cancel addTarget:self action:@selector(clickToCancle) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn_cancel];
        UIButton * btn_sure = [[UIButton alloc]init];
        btn_sure.frame = CGRectMake(SCREEN_WIDTH - 60, 0,  60, 40);
        [btn_sure setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [btn_sure setTitleColor:[UIColor colorWithRed:112/255.0 green:115/255.0 blue:144/255.0 alpha:1] forState:UIControlStateNormal];
        [btn_sure addTarget:self action:@selector(clickToSure:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn_sure];
        //创建时间选择器
        UIDatePicker * dateP = [[UIDatePicker alloc]init];
        dateP.datePickerMode = UIDatePickerModeDateAndTime;
        dateP.frame = CGRectMake(0, 40, SCREEN_WIDTH, 160);
        dateP.minimumDate = [NSDate date];
        dateP.maximumDate = [NSDate dateWithTimeInterval:3600 * 24 * 7 sinceDate:[NSDate date]];
        [dateP addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
        [dateP setDate:selecterDate animated:YES];
        [view_bj addSubview:dateP];
    }
}
-(void)creatDatePickerWithObj:(HZQDatePicker *)datePicker
                     withDate:(NSDate *)selecterDate
           withMinuteInterval:(NSInteger)minuteInterval
           withDatePickerMode:(NSInteger)DatePickerMode{
    if (selecterDate == nil) {
        selecterDate = [NSDate date];
    }
    _selecterDate = selecterDate;
    datePicker.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    datePicker.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    [window addSubview:datePicker];
    _datePicker = datePicker;
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToCancle)];
    [datePicker addGestureRecognizer:tapGestureRecognizer];
    if (view_bj == nil) {
        //创建白色的背景层
        view_bj = [[UIView alloc]init];
        view_bj.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        view_bj.backgroundColor = [UIColor whiteColor];
        view_bj.layer.cornerRadius = 4;
        view_bj.clipsToBounds  = YES;
        [datePicker addSubview:view_bj];
        //创建一层灰色的
        UIView * view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [view_bj addSubview:view];
        //创建取消和确定的按钮
        UIButton * btn_cancel = [[UIButton alloc]init];
        btn_cancel.frame = CGRectMake(0, 0, 60, 40);
        [btn_cancel setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [btn_cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn_cancel addTarget:self action:@selector(clickToCancle) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn_cancel];
        UIButton * btn_sure = [[UIButton alloc]init];
        btn_sure.frame = CGRectMake(SCREEN_WIDTH - 60, 0,  60, 40);
        [btn_sure setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [btn_sure setTitleColor:[UIColor colorWithRed:112/255.0 green:115/255.0 blue:144/255.0 alpha:1] forState:UIControlStateNormal];
        [btn_sure addTarget:self action:@selector(clickToSure:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn_sure];
        //创建时间选择器
        UIDatePicker * dateP = [[UIDatePicker alloc]init];
        dateP.datePickerMode = DatePickerMode;
        dateP.minuteInterval = minuteInterval;
        dateP.frame = CGRectMake(0, 40, SCREEN_WIDTH, 160);
        dateP.minimumDate = [NSDate date];
        dateP.maximumDate = [NSDate dateWithTimeInterval:3600 * 24 * 7 sinceDate:[NSDate date]];
        [dateP addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
        [dateP setDate:selecterDate animated:YES];
        [view_bj addSubview:dateP];
    }
}

#pragma mark - 这是点击背景/取消调用的方法
-(void)clickToCancle{
    [_datePicker removeFromSuperview];
    _datePicker = nil;
    [view_bj removeFromSuperview];
    view_bj = nil;
}
#pragma mark - 这是点击确定的方法
-(void)clickToSure:(UIButton *)sender{
    if (time == nil &&[_selecterDate compare:[NSDate date]] == NSOrderedAscending){
        time = [HZQChangeDateLine ExchangeWithdate:[NSDate date] withString:@"yyyy-MM-dd HH:mm"];
    }
    if (time == nil) {
        time = [HZQChangeDateLine ExchangeWithdate:_selecterDate withString:@"yyyy-MM-dd HH:mm"];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(getDatePickerTime:)]) {
        [self.delegate getDatePickerTime:time];
    }
    if (self.myBlock) {
        self.myBlock(time);
    }
    [self clickToCancle];
}
#pragma mark - 时间选择器的值发生改变会调用的方法
-(void)changeValue:(UIDatePicker *)picker{
    NSLog(@"%@",[HZQChangeDateLine ExchangeWithdate:picker.date withString:@"yyyy-MM-dd HH:mm"]);
    time = [HZQChangeDateLine ExchangeWithdate:picker.date withString:@"yyyy-MM-dd HH:mm"];
}
@end
