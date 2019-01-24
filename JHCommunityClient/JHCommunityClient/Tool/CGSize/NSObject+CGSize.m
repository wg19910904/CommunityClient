//
//  NSObject+CGSize.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "NSObject+CGSize.h"

@implementation NSObject (CGSize)
-(CGSize)currentSizeWithString:(NSString *)str font:(UIFont *)font withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    //根据换行样式、字体决定大小
    CGSize size=[str boundingRectWithSize:CGSizeMake(WIDTH - width, height)
                                  options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                               attributes:dict
                                  context:nil].size;
    return size;
}
-(CGSize)currentSizeWithString:(NSString *)str font:(UIFont *)font withWidth:(CGFloat)width
{
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    //根据换行样式、字体决定大小
    CGSize size=[str boundingRectWithSize:CGSizeMake(WIDTH - width,1000)
                                  options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                               attributes:dict
                                  context:nil].size;
    
    return size;
}
@end
