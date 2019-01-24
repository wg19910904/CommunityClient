//
//  HZQChangeDateLine.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZQChangeDateLine : NSObject
/**
 *  将时间戳转化为时间(年-月-日 时:分)
 *
 *  @param dateLine 传进来的时间戳
 *
 *  @return 转化好的时间
 */
+(NSString *)dateLineExchangeWithTime:(NSString *)dateLine;
/**
 *  将时间戳转化为时间(月-日 时:分)
 *
 *  @param dateLine 传进来的时间戳
 *
 *  @return 转化好的时间
 */
+(NSString *)ExchangeWithDateLine:(NSString *)dateLine;
/**
 *  将date转化为时间
 *
 *  @param date    传进来的date
 *  @param string 传进来的格式
 *
 *  @return 返回的时间
 */
+(NSString *)ExchangeWithdate:(NSDate *)date withString:(NSString * )string;
/**
 *  将时间戳转化为时间(年-月-日)
 *
 *  @param dateLine 传进来的时间戳
 *
 *  @return 转化好的时间
 */
+(NSString *)ExchangeWithDateline:(NSString *)dateLine;
/**
 *  将时间转化为时间戳
 *
 *  @param time 时间
 *
 *  @return 返回的时间戳
 */
+(NSInteger )ExchangeWithTime:(NSString *)time;
/**
 *  将时间转化为date
 *
 *  @param timeString (2016-5-5)
 *
 *  @return 返回的date
 */
+(NSDate * )ExchangeWithTimeString:(NSString *)timeString;
+(NSDate * )getDateString:(NSString *)timeString;
@end
