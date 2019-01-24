//
//  TransformTime.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/7.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransformTime : NSString
//时间戳转换时间
+ (NSString *)transfromWithString:(NSString *)str withFormat:(NSString *)format;


@end
