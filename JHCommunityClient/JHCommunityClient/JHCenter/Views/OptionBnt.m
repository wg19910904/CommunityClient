//
//  OptionBnt.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "OptionBnt.h"

@implementation OptionBnt

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return FRAME(20, 0, 30, 20);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return FRAME(0, 2.5, 15, 15);
}
@end
