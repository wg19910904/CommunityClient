//
//  BuyTableViewCellThree.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/2/27.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "BuyTableViewCellThree.h"
#import <Masonry.h>
@implementation BuyTableViewCellThree

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.mySwitch == nil) {
        self.mySwitch = [[UISwitch alloc]init];
        self.mySwitch.on = YES;
        self.mySwitch.onTintColor = THEME_COLOR;
        self.mySwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.mySwitch.frame = CGRectMake(WIDTH-50, 30, 30, 50);
        [self addSubview:self.mySwitch];
        self.mySwitch.hidden = YES;
//        self.myImageView = [[UIImageView alloc]init];
//        self.myImageView.frame = CGRectMake(WIDTH-25, 10, 15, 15);
//        self.myImageView.image = [UIImage imageNamed:@"Prompt"];
//        [self addSubview:self.myImageView];
//        UILabel * label = [[UILabel alloc]init];
//        label.frame = CGRectMake(WIDTH-70, 10, 50, 15);
//        label.text = NSLocalizedString(@"资金托管", nil);
//        label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
//        label.font = [UIFont systemFontOfSize:10];
//        [self addSubview:label];
        UIImageView * imageView2 = [[UIImageView alloc]init];
        imageView2.frame = CGRectMake(15, 10, 20, 20);
        imageView2.image = [UIImage imageNamed:@"money"];
        [self addSubview:imageView2];
        UILabel * label1 = [[UILabel alloc]init];
        label1.frame = CGRectMake(45, 13, 100, 20);
        label1.text = NSLocalizedString(@"商品预估费用", nil);
        label1.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label1.font = [UIFont systemFontOfSize:14];
        [self addSubview:label1];
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-0);
            make.left.offset(0);
            make.right.offset(-0);
            make.height.offset(40);
        }];
        UILabel * line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [view addSubview:line];
        line.frame = CGRectMake(0, 39, WIDTH, 1);
        self.myTextField = [[UITextField alloc]init];
        self.myTextField.frame = CGRectMake(10, 0, WIDTH/2.0, 40);
        self.myTextField.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        self.myTextField.placeholder = NSLocalizedString(@"请输入金额", nil);
        self.myTextField.font = [UIFont systemFontOfSize:13];
        self.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        [view addSubview:self.myTextField];
    }
}

@end
