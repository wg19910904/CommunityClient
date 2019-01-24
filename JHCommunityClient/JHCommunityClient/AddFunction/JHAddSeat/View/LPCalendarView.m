//
//  LPCalendarView.m
//  Calendar
//
//  Created by yiqiang on 16/7/12.
//  Copyright © 2016年 yiqiang. All rights reserved.
//

#import "LPCalendarView.h"
#import "HZQChangeDateLine.h"
@implementation LPCalendarView
{
    UIButton  *_selectButton;
    NSMutableArray *_daysArray;
    
    UILabel *headlabel;
    
    UIButton *rightButton;
    UIImageView *rightImg;
    NSDate *lpDate;
    UIButton * oldBtn;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            
            UIButton *button = [[UIButton alloc] init];
            [self addSubview:button];
            [_daysArray addObject:button];
        }
    }
    return self;
}
#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    [self createCalendarViewWith:date];
}
- (void)createCalendarViewWith:(NSDate *)date{
    lpDate=self.date;
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = 38;
    // 1.year month
    headlabel = [[UILabel alloc] init];
    if ([LPCalendarDate month:date] < 10) {
         headlabel.text = [NSString stringWithFormat:@"%li-0%li",[LPCalendarDate year:date],[LPCalendarDate month:date]];
    }else{
        headlabel.text = [NSString stringWithFormat:@"%li-%li",[LPCalendarDate year:date],[LPCalendarDate month:date]];
 
    }
    headlabel.font   = [UIFont systemFontOfSize:14];
    headlabel.frame  = CGRectMake( self.frame.size.width/2-35, 0, 70, itemH);
    headlabel.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:headlabel];
    
    //last month
    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButton.frame=CGRectMake(0, 0, 40, itemH);
    [leftButton addTarget:self action:@selector(clickMonth:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"arrow-l copy"] forState:UIControlStateNormal];
    [self addSubview:leftButton];
    //next month   if greater than the current month does not show
    rightButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame=CGRectMake(WIDTH - leftButton.width, leftButton.y, leftButton.width, leftButton.height);
    [rightButton addTarget:self action:@selector(clickMonth:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"arrow-r copy"] forState:UIControlStateNormal];
    [self addSubview:rightButton];
    // 2.weekday
    NSArray *array = @[NSLocalizedString(@"周日", nil), NSLocalizedString(@"周一", nil), NSLocalizedString(@"周二", nil), NSLocalizedString(@"周三", nil), NSLocalizedString(@"周四", nil), NSLocalizedString(@"周五", nil), NSLocalizedString(@"周六", nil)];
    UIView *weekBg = [[UIView alloc] init];
    weekBg.frame = CGRectMake(0, CGRectGetMaxY(headlabel.frame), self.frame.size.width, itemH-10);
    [self addSubview:weekBg];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = HEX(@"f5f5f5", 1.0);
        week.textColor       = [UIColor blackColor];
        [weekBg addSubview:week];
    }
    
    NSInteger daysInLastMonth = [LPCalendarDate totaldaysInMonth:[LPCalendarDate lastMonth:date]];
    NSInteger daysInThisMonth = [LPCalendarDate totaldaysInMonth:date];
    NSInteger firstWeekday    = [LPCalendarDate firstWeekdayInThisMonth:date];
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame);
        
        UIButton *dayButton = _daysArray[i];
        
        dayButton.frame = CGRectMake(x, y, itemW, itemH);
        
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = 5;
        [dayButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dayButton setBackgroundColor:_selecter_color forState:UIControlStateSelected];
         [dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger day = 0;
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", day] forState:UIControlStateNormal];
        // this month
        NSInteger todayIndex = [LPCalendarDate day:[NSDate date]] + firstWeekday - 1;
        
        if([self judgementMonth] && i ==  todayIndex)
        {
            [self setStyle_Today:dayButton];
            _dayButton = dayButton;
        }else
        {
            dayButton.backgroundColor=[UIColor whiteColor];
        }
        NSString * da = [NSString stringWithFormat:@"%@-%@",headlabel.text,dayButton.titleLabel.text];
        if ([da isEqualToString:self.time]) {
            dayButton.selected = YES;
            oldBtn = dayButton;
        }
    }
}


#pragma mark - date button style
//设置不是本月的日期字体颜色   ---白色  看不到
- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(BOOL) judgementMonth
{
    //获取当前月份
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"MM";
    NSInteger dateMon=[[formatter stringFromDate:[NSDate date]] integerValue];
    
    //获取选择的月份
    NSInteger mon=[[headlabel.text substringFromIndex:5] integerValue];
    
    if (mon==dateMon)
    {
        return YES;
    }else
        return NO;
}
- (void)setStyle_Today:(UIButton *)btn
{
    //btn.selected = YES;
    //oldBtn = btn;
}

-(void) clickMonth:(UIButton *)btn
{
    if (btn==rightButton)
    {
        lpDate=[LPCalendarDate nextMonth:lpDate];
    }else
    {
        lpDate=[LPCalendarDate lastMonth:lpDate];
    }

    NSDate *date=lpDate;
    
    if ([LPCalendarDate month:date] < 10) {
        headlabel.text     = [NSString stringWithFormat:@"%li-0%li",[LPCalendarDate year:date],[LPCalendarDate month:date]];
    }else{
        headlabel.text     = [NSString stringWithFormat:@"%li-%li",[LPCalendarDate year:date],[LPCalendarDate month:date]];
        
    }
    
    NSInteger daysInLastMonth = [LPCalendarDate totaldaysInMonth:[LPCalendarDate lastMonth:date]];
    NSInteger daysInThisMonth = [LPCalendarDate totaldaysInMonth:date];
    NSInteger firstWeekday    = [LPCalendarDate firstWeekdayInThisMonth:date];
    
    NSInteger todayIndex = [LPCalendarDate day:[NSDate date]] + firstWeekday - 1;
    
    for (int i = 0; i < 42; i++) {
        
        UIButton *dayButton = _daysArray[i];
        
        NSInteger day = 0;
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        if (headlabel.text) {
            
        }
        [dayButton setTitle:[NSString stringWithFormat:@"%li", day] forState:UIControlStateNormal];
          NSString * time = [HZQChangeDateLine ExchangeWithdate:[NSDate date] withString:@"yyyy-MM"];
        if ([headlabel.text compare:time] == NSOrderedAscending) {
            [dayButton setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateNormal];
             dayButton.enabled = NO;
        }else{
            [dayButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
             dayButton.enabled = YES;
        }
        // this month
        if([self judgementMonth] && i ==  todayIndex)
        {
            //[self setStyle_Today:dayButton];
             _dayButton = dayButton;
        }else
        {
            dayButton.backgroundColor=[UIColor whiteColor];
            
        }
        dayButton.selected = NO;
    }
}
#pragma mark - 这是点击日历的方法
-(void)logDate:(UIButton * )sender{
    NSLog(@"点击了:%@-%@",headlabel.text,sender.titleLabel.text);
    oldBtn.selected = NO;
    sender.selected = !sender.selected;
    oldBtn = sender;
    if (self.myBlock) {
        self.myBlock([NSString stringWithFormat:@"%@-%@",headlabel.text,sender.titleLabel.text]);
    }
}
@end
