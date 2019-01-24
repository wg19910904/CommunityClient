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
 *  距离现在多长时间
 *
 *  @param unixTime 时间戳
 *
 *  @return 在当前时间之前多久的时间
 */
+(NSString *)distanceTimeFormNow:(NSInteger)unixTime;
@end
