//
//  NSDateToString.h
//  WaimaiShop
//
//  Created by xixixi on 16/1/5.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateToString : NSObject
+(NSString *)stringFromUnixTime:(NSString *)timeInterval;
+(NSString *)stringFromUnixTime:(NSString *)timeInterval withCharacter:(NSString *)c_string;
@end
