//
//  HZQChangeDateLine.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "HZQChangeDateLine.h"

@implementation HZQChangeDateLine
+(NSString *)dateLineExchangeWithTime:(NSString *)dateLine{
    NSInteger num = [dateLine integerValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}

+(NSString *)ExchangeWithDateLine:(NSString *)dateLine{
    NSInteger num = [dateLine integerValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}
+(NSString *)ExchangeWithdate:(NSDate *)date withString:(NSString *)string{
    if (string == nil) {
        string = @"yyyy-MM-dd HH:mm";
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:string];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}
+(NSString *)ExchangeWithDateline:(NSString *)dateLine{
    NSInteger num = [dateLine integerValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}
+(NSInteger )ExchangeWithTime:(NSString *)time{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [dateFormatter dateFromString:time];
    NSInteger dateline = [date timeIntervalSince1970];
    return dateline;
}
+(NSDate * )ExchangeWithTimeString:(NSString *)timeString{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [dateFormatter dateFromString:timeString];
    return date;
}
+(NSDate * )getDateString:(NSString *)timeString{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:timeString];
    return date;
}

@end
