//
//  UIImage+color.m
//  ssd909i0
//
//  Created by yang on 15/10/20.
//  Copyright © 2015年 yang. All rights reserved.
//

#import "UIImage+color.h"

@implementation UIImage (color)

+ (UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, rect);
    
    UIImage* curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return curImage;
}




@end
