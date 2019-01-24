//
//  SendTableViewCellTwo.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SendTableViewCellTwo.h"

@implementation SendTableViewCellTwo

//@property(nonatomic,retain)UIImageView * imageV;
//@property(nonatomic,retain)UILabel * myLabel;
//@property(nonatomic,retain)UITextField * myTextField;
//@property(nonatomic,retain)UIImageView * imageVV;
//@property(nonatomic,retain)UIImageView * imageV1;
//@property(nonatomic,retain)UILabel * myLabel1;
//@property(nonatomic,retain)UITextField * myTextField1;
//@property(nonatomic,retain)UIView * myView;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.imageV == nil) {
//        //创建前面的imageView
//        self.imageV = [[UIImageView alloc]init];
//        self.imageV.frame = CGRectMake(10, 12.5, 15, 15);
//        [self addSubview:self.imageV];
//        //创建前面的label
//        self.myLabel = [[UILabel alloc]init];
//        self.myLabel.frame = CGRectMake(30, 13.5, 60, 15);
//        self.myLabel.font = [UIFont systemFontOfSize:13];
//        self.myLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
//        [self addSubview:self.myLabel];
//        //创建textField
//        self.myTextField = [[UITextField alloc]init];
//        self.myTextField.frame = CGRectMake(90, 1, CGRectGetWidth(self.frame)-90-25, 38);
//        self.myTextField.font = [UIFont systemFontOfSize:13];
//        self.myTextField.textColor = [UIColor colorWithWhite:0.5 alpha:1];
//        [self addSubview:self.myTextField];
//        self.myView = [[UIView alloc]init];
//        self.myView.frame = CGRectMake(0, 42, WIDTH, 45);
//        self.myView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
//        [self addSubview:self.myView];
//        //创建前面的imageView
//        self.imageV1 = [[UIImageView alloc]init];
//        self.imageV1.frame = CGRectMake(10, 101.5, 15, 15);
//        [self addSubview:self.imageV1];
//        //创建前面的label
//        self.myLabel1 = [[UILabel alloc]init];
//        self.myLabel1.frame = CGRectMake(30, 101.5, 60, 15);
//        self.myLabel1.font = [UIFont systemFontOfSize:13];
//         self.myLabel1.textColor = [UIColor colorWithWhite:0.5 alpha:1];
//        [self addSubview:self.myLabel1];
//        //创建textField
//        self.myTextField1 = [[UITextField alloc]init];
//        self.myTextField1.frame = CGRectMake(90, 90, CGRectGetWidth(self.frame)-90-55, 38);
//        self.myTextField1.font = [UIFont systemFontOfSize:13];
//        self.myTextField1.textColor = [UIColor colorWithWhite:0.5 alpha:1];
//        [self addSubview:self.myTextField1];
//        //创建后面的箭头
//        self.imageVV = [[UIImageView alloc]init];
//        self.imageVV.frame = CGRectMake(CGRectGetWidth(self.frame) - 25, 100, 8, 16);
//        [self addSubview:self.imageVV];
//        self.imageVV.image = [UIImage imageNamed:@"jiantou"];
//        //创建分割线
//        UILabel * label = [[UILabel alloc]init];
//        label.frame = CGRectMake(0, 131,WIDTH, 1);
//        label.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
//        [self addSubview:label];
//        //创建btn
//        self.btn = [[UIButton alloc]init];
//        self.btn.frame = CGRectMake(WIDTH-60, 10, 30, 110);
//        [self.btn setImage:[UIImage imageNamed:@"jiant"] forState:UIControlStateNormal];
//        [self addSubview:self.btn];
        self.imageV = [[UIImageView alloc]init];
        self.imageV.frame = CGRectMake(WIDTH - 45, 5, 30, 30);
        self.imageV.image = [UIImage imageNamed:@"switch"];
        [self addSubview:self.imageV];
        self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end
