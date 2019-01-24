//
//  HouseKeepingListBnt.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "MaintainListBnt.h"

@implementation MaintainListBnt
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:THEME_COLOR  forState:UIControlStateSelected];
        self.titleLabel.font = FONT(14);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setImage:IMAGE(@"arrowDown") forState:UIControlStateNormal];
        [self setImage:IMAGE(@"arrowUp") forState:UIControlStateSelected];
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 5, 90, 30);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(90, 17, 8, 5);
}
@end
