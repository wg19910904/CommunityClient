//
//  LPCalendarView.h
//  Calendar
//
//  Created by yiqiang on 16/7/12.
//  Copyright © 2016年 yiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPCalendarDate.h"

@interface LPCalendarView : UIView

@property (nonatomic, strong) NSDate *date;
@property (nonatomic,copy) NSString *time;
@property(nonatomic,retain)UIColor * selecter_color;//选中的颜色
//今天
@property (nonatomic,strong)  UIButton *dayButton;
@property(nonatomic,copy)void(^myBlock)(NSString * date);
@end
