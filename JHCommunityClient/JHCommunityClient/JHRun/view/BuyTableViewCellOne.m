//
//  BuyTableViewCellOne.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "BuyTableViewCellOne.h"

@implementation BuyTableViewCellOne

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.myImage == nil) {
        self.myImage = [[UIImageView alloc]init];
        self.myImage.image = [UIImage imageNamed:@"address"];
        self.myImage.frame = CGRectMake(10, 10, 15, 20);
        [self addSubview:self.myImage];
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 39, WIDTH, 1);
        label.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [self addSubview:label];
        UILabel * label1 = [[UILabel alloc]init];
        label1.frame = CGRectMake(40, 13, 55, 15);
        label1.text = NSLocalizedString(@"购买地址", nil);
        label1.font = [UIFont systemFontOfSize:13];
        label1.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:label1];
        self.myBtnOne = [[UIButton alloc]init];
        self.myBtnOne.tag = 1;
        self.myBtnOne.frame = CGRectMake(WIDTH/2.0-50, 5, 30, 30);
        [self.myBtnOne setImage:[UIImage imageNamed:@"selectCurrent"] forState:UIControlStateSelected];
        [self.myBtnOne setImage:[UIImage imageNamed:@"selectDefault"] forState:UIControlStateNormal];
        [self addSubview:self.myBtnOne];
        UILabel * label2 = [[UILabel alloc]init];
        label2.frame = CGRectMake(WIDTH/2.0+5-20, 13, 55, 15);
        label2.text = NSLocalizedString(@"指定地址", nil);
        label2.font = [UIFont systemFontOfSize:13];
        label2.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:label2];
        self.myBtnTwo = [[UIButton alloc]init];
        self.myBtnTwo.frame = CGRectMake(WIDTH/2.0+45, 5, 30, 30);
        self.myBtnTwo.tag = 2;
        [self.myBtnTwo setImage:[UIImage imageNamed:@"selectCurrent"] forState:UIControlStateSelected];
        [self.myBtnTwo setImage:[UIImage imageNamed:@"selectDefault"] forState:UIControlStateNormal];

        [self addSubview:self.myBtnTwo];
        UILabel * label3 = [[UILabel alloc]init];
        label3.frame = CGRectMake(WIDTH/2.0+80, 13, 70, 15);
        label3.text = NSLocalizedString(@"不指定地址", nil);
        label3.font = [UIFont systemFontOfSize:13];
        label3.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:label3];
        

    }
   
}

@end
