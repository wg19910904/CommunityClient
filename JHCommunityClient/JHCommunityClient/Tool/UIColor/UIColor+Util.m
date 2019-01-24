//
//  UIColor+Util.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "UIColor+Util.h"


@implementation UIColor (Util)

#pragma mark - Hex

+ (UIColor *)colorWithHex:(NSString *)hexValue alpha:(CGFloat)alpha
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    range.location =0;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green/255.0f)
                            blue:(float)(blue/255.0f)
                           alpha:alpha];
}


@end
