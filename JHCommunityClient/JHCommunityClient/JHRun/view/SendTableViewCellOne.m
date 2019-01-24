//
//  SendTableViewCellOne.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SendTableViewCellOne.h"

@implementation SendTableViewCellOne

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.imageV == nil) {
        //创建前面的imageView
        self.imageV = [[UIImageView alloc]init];
        self.imageV.frame = CGRectMake(10, 12.5, 15, 15);
        [self addSubview:self.imageV];
        //创建前面的label
        self.myLabel = [[UILabel alloc]init];
        self.myLabel.frame = CGRectMake(30, 13.5, 60, 15);
        self.myLabel.font = [UIFont systemFontOfSize:13];
        self.myLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.myLabel];
        //创建textField
        self.myTextField = [[UITextField alloc]init];
        self.myTextField.frame = CGRectMake(90, 1, CGRectGetWidth(self.frame)-90-25, 38);
        self.myTextField.font = [UIFont systemFontOfSize:13];
        self.myTextField.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.myTextField];
        //创建后面的箭头
        self.imageVV = [[UIImageView alloc]init];
        self.imageVV.frame = CGRectMake(CGRectGetWidth(self.frame) - 25, 12, 8, 16);
        [self addSubview:self.imageVV];
        self.imageVV.image = [UIImage imageNamed:@"jiantou"];
        //创建分割线
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 39,WIDTH, 1);
        label.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [self addSubview:label];
    }
    
}

@end
