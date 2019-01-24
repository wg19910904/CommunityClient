//
//  SendTableViewCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SendTableViewCell.h"

@implementation SendTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.myLabel == nil) {
        //创建前面的imageView
        self.imageV = [[UIImageView alloc]init];
        self.imageV.frame = CGRectMake(10, 12.5, 15, 15);
        self.imageV.image = [UIImage imageNamed:@"weight"];
        [self addSubview:self.imageV];
        //创建前面的label
        self.myLabel = [[UILabel alloc]init];
        self.myLabel.frame = CGRectMake(30, 13.5, 30, 15);
        self.myLabel.text = NSLocalizedString(@"重量", nil);
        self.myLabel.adjustsFontSizeToFitWidth = YES;
        self.myLabel.font = [UIFont systemFontOfSize:13];
        self.myLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.myLabel];
        self.wTextFiled = [[UITextField alloc]init];
        self.wTextFiled.frame = CGRectMake(70, 0, WIDTH/2-50, 40);
        self.wTextFiled.placeholder = NSLocalizedString(@"请输入重量", nil);
        self.wTextFiled.font = [UIFont systemFontOfSize:13];
        self.wTextFiled.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        UILabel * labe = [[UILabel alloc]init];
        labe.frame = CGRectMake(0, 0, 30, 40);
        labe.font = [UIFont systemFontOfSize:13];
        labe.textColor = [UIColor redColor];
        labe.text = @"/kg";
        self.wTextFiled.rightViewMode = UITextFieldViewModeAlways;
        self.wTextFiled.rightView = labe;
        [self addSubview:self.wTextFiled];
        self.wTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        UILabel * labb = [[UILabel alloc]init];
        labb.frame = CGRectMake(0, 39, WIDTH, 1);
        labb.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [self addSubview:labb];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end
