//
//  TransformTime.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/7.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "TransformTime.h"

@implementation TransformTime
//时间戳转换时间
+ (NSString *)transfromWithString:(NSString *)str withFormat:(NSString *)format
{
    
    NSTimeInterval time = [str integerValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
    
}

@end
