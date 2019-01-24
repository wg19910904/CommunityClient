//
//  JHSendOrderDetailCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSendOrderDetailCell.h"

@implementation JHSendOrderDetailCell
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.label == nil) {
        self.label = [[UILabel alloc]init];
        self.label.frame = FRAME(15, 20, WIDTH, 20);
        self.label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        self.label.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.label];
        self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end
