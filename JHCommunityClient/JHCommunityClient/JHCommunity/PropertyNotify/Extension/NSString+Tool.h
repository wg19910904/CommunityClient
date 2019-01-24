//
//  NSString+Tool.h
//  JHWaiMaiUpdate
//
//  Created by jianghu3 on 16/6/30.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tool)
/**
 *  md5加密
 *
 *  @param input 需要加密的str
 *
 *  @return MD5加密后的str
 */
+(NSString *)md5HexDigest:(NSString *)input;
/**
 获取时间戳
 
 @param date 需要获取时间戳的时间
 @param formate 时间的格式
 @return 时间戳
 */
+(NSInteger)getDatelineOfDate:(NSString *)date formate:(NSString *)formate;


/**
 *  格式化时间只有 时、分
 *
 *  @param unixTime 时间戳
 *
 *  @return 格式后的时间
 */
+(NSString *)formateDateHour:(NSInteger)unixTime;

/**
 *  格式化时间有年月日 时分
 *
 *  @param unixTime 时间戳
 *
 *  @return 格式后的时间
 */
+(NSString *)formateDateYear:(NSInteger)unixTime;

/**
 *  格式化时间有年月日
 *
 *  @param unixTime 时间戳
 *
 *  @return 格式后的时间
 */
+(NSString *)formateDateToDay:(NSInteger)unixTime;

/**
 *  格式化时间有月日 时分
 *
 *  @param unixTime 时间戳
 *
 *  @return 格式后的时间
 */
+(NSString *)formateDateMouth:(NSInteger)unixTime;

/**
 *  距离现在多长时间
 *
 *  @param unixTime 时间戳
 *
 *  @return 在当前时间之前多久的时间
 */
+(NSString *)distanceTimeFormNow:(NSInteger)unixTime;
/**
 *  格式化时间包含周几
 *
 *  @param unixTime 时间戳
 *
 *  @return 格式后的时间
 */
+(NSString *)formateDateToWeek:(NSInteger)unixTime;
/**
 获取AttributeString
 
 @param str 未处理过的str
 @param attributeDic 需要添加的属性
 @return 返回ttributeString
 */
+(NSAttributedString *)getAttributeString:(NSString *)str strAttributeDic:(NSDictionary *)attributeDic;

+(NSString *)formateDate:(NSString *)formate dateline:(NSInteger)unixTime;

+(NSString *)getStrFromFloatValue:(float)ft bitCount:(int)bitCount;

+(NSAttributedString *)getAttributeString:(NSString *)str dealStr:(NSString *)dealStr strAttributeDic:(NSDictionary *)attributeDic;

+(NSAttributedString *)addAttributeString:(NSAttributedString *)str dealStr:(NSString *)dealStr strAttributeDic:(NSDictionary *)attributeDic;

// 获取带有行间距的字符串
+(NSAttributedString *)getParagraphStyleAttributeStr:(NSString *)str lineSpacing:(float)lineSpace;

// 获取带有行间距的字符串
+(NSAttributedString *)addParagraphStyleAttributeStrWithAttributeStr:(NSAttributedString *)attStr lineSpacing:(float)lineSpace;

@end
