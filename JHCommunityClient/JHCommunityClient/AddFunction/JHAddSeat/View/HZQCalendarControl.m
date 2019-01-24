//
//  HZQCalendarControl.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/24.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "HZQCalendarControl.h"
#import "LPCalendarView.h"
#import "HZQChangeDateLine.h"
@implementation HZQCalendarControl
{
    HZQCalendarControl * control;
    NSString * text;
    NSString * currentTime;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(HZQCalendarControl *)creatCalendarControlWithTime:(NSString *)time  withSelecterColor:(UIColor *)selColor{
    HZQCalendarControl * view = [[HZQCalendarControl alloc]init];
    [view  creatCalendarControlWithTime:time withView:view withSelecterColor:selColor];
    return view;
}
-(void)creatCalendarControlWithTime:(NSString *)time withView:(HZQCalendarControl *)view  withSelecterColor:(UIColor *)selColor{
    control = view;
    currentTime = time;
    view.frame = FRAME(0, 0, WIDTH, HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    [view addTarget:self action:@selector(clickToRemove) forControlEvents:UIControlEventTouchUpInside];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:view];
    UIView * center_view = [[UIView alloc]init];
    center_view.frame = FRAME(0, HEIGHT, WIDTH, HEIGHT/2);
    center_view.backgroundColor = [UIColor whiteColor];
    [view addSubview:center_view];
    [UIView animateWithDuration:0.3 animations:^{
       center_view.frame = FRAME(0, HEIGHT/2, WIDTH, HEIGHT/2);
    }];
    LPCalendarView *calendarView=[[LPCalendarView alloc] init];
    calendarView.frame=CGRectMake(0, 0, WIDTH, HEIGHT/2 );
    calendarView.time = time;
    calendarView.selecter_color = selColor;
    calendarView.date= [HZQChangeDateLine getDateString:time];
    [calendarView setMyBlock:^(NSString * date) {
        text = date;
    }];
    [center_view addSubview:calendarView];
    //创建底部确定的按钮
    [center_view addSubview:self.sureBtn];
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]init];
        _sureBtn.frame = FRAME(0, HEIGHT/2 - 44, WIDTH, 44);
        CALayer * layer = [[CALayer alloc]init];
        layer.frame = FRAME(0, 0, WIDTH, 0.5);
        layer.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        [_sureBtn.layer addSublayer:layer];
        [_sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = FONT(14);
        _sureBtn.backgroundColor = [UIColor whiteColor];
        [_sureBtn addTarget:self action:@selector(clickToRemove) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sureBtn;
}
#pragma mark - 这是点击移除的方法
-(void)clickToRemove{
    [control removeFromSuperview];
    control = nil;
    if (self.myBlock) {
        if (text == nil) {
             self.myBlock(currentTime);
        }else{
            self.myBlock(text);
        }
    }
}
@end
