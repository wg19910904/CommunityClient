//
//  JHAllCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHAllCell.h"

@implementation JHAllCell
{
    UIImageView * imageV;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (imageV == nil) {
        imageV = [[UIImageView alloc]init];
        imageV.bounds = CGRectMake(0, 0, 180, 150);
        imageV.center = CGPointMake(self.center.x, self.center.y -100);
        [self addSubview:imageV];
        imageV.image = [UIImage imageNamed:@"noMessage"];
    }
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    
    
}

@end
