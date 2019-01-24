//
//  LPCalendarDate.h
//  Calendar
//
//  Created by yiqiang on 16/7/12.
//  Copyright © 2016年 yiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPCalendarDate : NSObject

+ (NSInteger)day:(NSDate *)date;
+ (NSInteger)month:(NSDate *)date;
+ (NSInteger)year:(NSDate *)date;

+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
+ (NSInteger)totaldaysInMonth:(NSDate *)date;

+ (NSDate *)lastMonth:(NSDate *)date;
+ (NSDate*)nextMonth:(NSDate *)date;

@end
