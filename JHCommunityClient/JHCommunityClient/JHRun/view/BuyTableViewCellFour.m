//
//  BuyTableViewCellFour.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/27.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "BuyTableViewCellFour.h"

@implementation BuyTableViewCellFour

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.myLabel == nil) {
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(10, 12.5, 60, 15);
        label.text = NSLocalizedString(@"合计费用", nil) ;
        label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        self.myLabel = [[UILabel alloc]init];
        self.myLabel.frame = CGRectMake(90, 12.5, 80, 15);
        self.myLabel.textColor = [UIColor redColor];
        self.myLabel.text = @"";
        self.myLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.myLabel];
    }
}

@end
