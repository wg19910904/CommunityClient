//
//  TimeBnt.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/21.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "TimeBnt.h"

@implementation TimeBnt
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        self.weekLabel = [[UILabel alloc] initWithFrame:FRAME(0, 5, 40, 10)] ;
        _weekLabel.textColor = HEX(@"666666", 1.0f);
        _weekLabel.textAlignment = NSTextAlignmentCenter;
        _weekLabel.font = FONT(12);
        [self addSubview:_weekLabel];
        self.dayLabel = [[UILabel alloc] initWithFrame:FRAME(0, 25, 40, 10)];
        self.dayLabel.textColor = HEX(@"999999", 1.0f);
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.font = FONT(14);
        [self addSubview:self.dayLabel];
        [self setTitleColor:THEME_COLOR forState:UIControlStateSelected];
    }
    return self;
}

@end
