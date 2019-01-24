//
//  TakeawayOrderDetailCellOne.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "TakeawayOrderDetailCellOne.h"

@implementation TakeawayOrderDetailCellOne

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.imageV == nil) {
        self.imageV = [[UIImageView alloc]init];
        self.imageV.frame = FRAME(10, 15, 20, 20);
        [self addSubview:self.imageV];
        //创建分割线
        UIView  * label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 49.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
        self.label = [[UILabel alloc]init];
        self.label.frame = FRAME(40, 15, WIDTH/2, 20);
        self.label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        self.label.font = [UIFont systemFontOfSize:14];
        self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        [self addSubview:self.label];
    }
   
}

@end
