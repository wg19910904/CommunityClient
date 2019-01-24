//
//  NSObject+CGSize.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CGSize)


-(CGSize)currentSizeWithString:(NSString *)str font:(UIFont *)font withWidth:(CGFloat)width withHeight:(CGFloat)height;
-(CGSize)currentSizeWithString:(NSString *)str font:(UIFont *)font withWidth:(CGFloat)width;
@end
