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

+(NSString *)formateDateMouth:(NSInteger)unixTime{
    
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
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
+(NSString *)formateDate:(NSString *)formate dateline:(NSInteger)unixTime{
    
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}
+(NSInteger)getDatelineOfDate:(NSString *)date formate:(NSString *)formate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    NSDate *distanceDate = [dateFormatter dateFromString:date];
    return [distanceDate timeIntervalSince1970];
}
+(NSString *)distanceTimeFormNow:(NSInteger)unixTime{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSInteger longtime = (-1)*[date timeIntervalSinceNow];
    int day=(int)longtime/(3600*24);
    int hour=(int)(longtime-day*24*3600)/3600;
    int min=(int)(longtime-day*24*3600-3600*hour)/60;
    NSString *str=@"";
    if (day==0) {
        if (hour==0) {
            if (min==0)  str=@"1分钟前";
            else str=[NSString stringWithFormat:@"%d分钟前",min];
        }else str=[NSString stringWithFormat:@"%d小时前",hour];
    }else str=[NSString stringWithFormat:@"%d天",day];
    
    return str;
}
+(NSString *)formateDateToWeek:(NSInteger)unixTime{
    
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd EE HH:mm"];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}
/**
 获取AttributeString
 
 @param str 未处理过的str
 @param attributeDic 需要添加的属性
 @return 返回ttributeString
 */
+(NSAttributedString *)getAttributeString:(NSString *)str strAttributeDic:(NSDictionary *)attributeDic{
    if (str.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttributes:attributeDic range:NSMakeRange(0, str.length)];
    return att.copy;
}
+(NSString *)getStrFromFloatValue:(float)ft bitCount:(int)bitCount{
    
    int count = 0;
    float p = ft;
    for (NSInteger i=0; i<bitCount; i++) {
        
        p = p - (int)p;
        if (p == 0) {
            if (i == 0) {
                return [NSString stringWithFormat:@"%d",(int)ft];
            }
        }else{
            count++;
        }
        p = p * 10;
        
    }
    
    NSString *str = [NSString stringWithFormat:@"%@.%df",@"%",count];
    return [NSString stringWithFormat:str,ft];
    
}
+(NSAttributedString *)getAttributeString:(NSString *)str dealStr:(NSString *)dealStr strAttributeDic:(NSDictionary *)attributeDic{
    if (str.length == 0 || dealStr.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSRange range = [str rangeOfString:dealStr];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttributes:attributeDic range:range];
    return att.copy;
}

+(NSAttributedString *)addAttributeString:(NSAttributedString *)str dealStr:(NSString *)dealStr strAttributeDic:(NSDictionary *)attributeDic{
    if (str.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSRange range = [str.string rangeOfString:dealStr options:NSBackwardsSearch];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    [att addAttributes:attributeDic range:range];
    return att.copy;
}

// 获取带有行间距的字符串
+(NSAttributedString *)getParagraphStyleAttributeStr:(NSString *)str lineSpacing:(float)lineSpace{
    
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    return attStr.copy;
}

// 获取带有行间距的字符串
+(NSAttributedString *)addParagraphStyleAttributeStrWithAttributeStr:(NSAttributedString *)attStr lineSpacing:(float)lineSpace{
    
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithAttributedString:attStr];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    return attributeStr.copy;
    
}
@end
