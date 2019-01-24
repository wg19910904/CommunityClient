//
//  UIImage+color.h
//  ssd909i0
//
//  Created by yang on 15/10/20.
//  Copyright © 2015年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (color)

/**
 *  通过颜色获取图片
 *
 *  @param color 颜色
 *
 *  @return 返回的颜色图片
 */
+ (UIImage*)imageWithColor:(UIColor*)color;

@end
