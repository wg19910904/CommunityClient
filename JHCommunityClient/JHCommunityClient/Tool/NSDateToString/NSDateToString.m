//
//  NSDateToString.m
//  WaimaiShop
//
//  Created by xixixi on 16/1/5.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "NSDateToString.h"

@implementation NSDateToString
+(NSString *)stringFromUnixTime:(NSString *)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [timeInterval integerValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return  [dateFormatter stringFromDate:date];
}
+(NSString *)stringFromUnixTime:(NSString *)timeInterval withCharacter:(NSString *)c_string
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [timeInterval integerValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd",c_string,c_string];
    return  [dateFormatter stringFromDate:date];
}
@end
