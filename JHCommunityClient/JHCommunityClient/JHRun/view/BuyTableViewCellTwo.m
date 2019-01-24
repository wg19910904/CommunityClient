//
//  BuyTableViewCellTwo.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "BuyTableViewCellTwo.h"

@implementation BuyTableViewCellTwo


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.label == nil) {
        self.label = [[UILabel alloc]init];
        self.label.frame = CGRectMake(10, 12.5, 80, 15);
        self.label.text = NSLocalizedString(@"指定购买地址", nil);
        self.label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        self.label.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.label];
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 39, WIDTH, 1);
        label.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [self addSubview:label];
        //创建后面的箭头
        self.imageVV = [[UIImageView alloc]init];
        self.imageVV.frame = CGRectMake(CGRectGetWidth(self.frame) - 25, 12, 8, 16);
        [self addSubview:self.imageVV];
        self.imageVV.image = [UIImage imageNamed:@"jiantou"];
        //创建textField
        self.myTextField = [[UITextField alloc]init];
        self.myTextField.frame = CGRectMake(100, 1, CGRectGetWidth(self.frame)-100-25, 38);
        self.myTextField.font = [UIFont systemFontOfSize:13];
        self.myTextField.placeholder = NSLocalizedString(@"请输入购买地址", nil);
        self.myTextField.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.myTextField];

    }
}

@end
