//
//  NSString+Tool.m
//  JHWaiMaiUpdate
//
//  Created by jianghu3 on 16/6/30.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "NSString+Tool.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Tool)

+(NSString *)md5HexDigest:(NSString *)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

+(NSString *)formateDateHour:(NSInteger)unixTime{
    
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}

+(NSString *)formateDateYear:(NSInteger)unixTime{
    
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}

+(NSString *)formateDateToDay:(NSInteger)unixTime{
    
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}

+(NSString *)distanceTimeFormNow:(NSInteger)unixTime{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSInteger longtime = [date timeIntervalSinceNow];
    int day=(int)longtime/(3600*24);
    int hour=(int)(longtime-day*24*3600)/3600;
    int min=(int)(longtime-day*24*3600-3600*hour)/60;
    NSString *str;
    if (day==0) {
        if (hour==0) {
            if (min==0)  str=@"-1分钟前";
            else str=[NSString stringWithFormat:@"%d分钟前",min];
        }else{
            if (min==0) {
                str=[NSString stringWithFormat:@"%d小时前",hour];
            }else{
                str=[NSString stringWithFormat:@"%d小时%d分钟前",hour,min];
            }
        }
    }else{
        if (hour==0) {
            if (min==0)  str=[NSString stringWithFormat:@"%d天",day];
            else str=[NSString stringWithFormat:@"%d天%d分钟前",day,min];
        }else{
            if (min==0) {
                str=[NSString stringWithFormat:@"%d天%d小时前",day,hour];
            }else{
                str=[NSString stringWithFormat:@"%d天%d小时%d分钟前",day,hour,min];
            }
        }
    }
    
    return str;
}
@end
