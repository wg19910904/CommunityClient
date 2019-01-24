//
//  JHUPKeepOrderDetailCellThree.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHUPKeepOrderDetailCellThree.h"

@implementation JHUPKeepOrderDetailCellThree
{
    UILabel * label_state;//显示订单状态的
    UILabel * label_line;//创建分割线
}

- (void)awakeFromNib {
    // Initialization code
}
-(void)setModel:(OrderModel *)model{
    _model = model;
    if (label_state == nil) {
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(15, 5, WIDTH/2, 50);
        label_state.numberOfLines = 0;
        [self addSubview:label_state];
    }
    NSString * str = @"等待接单(订单已提交)订单超过三小时自动取消";
    NSRange range = [str rangeOfString:@"等待接单"];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str];
    [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:range];
    label_state.text = str;
    label_state.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    label_state.font = [UIFont systemFontOfSize:13];
    label_state.attributedText = attributed;
    if(label_line == nil){
        label_line = [[UILabel alloc]init];
        label_line.frame = FRAME(0, 59.5, WIDTH, 0.5);
        [self addSubview:label_line];
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    }
    //创建按钮
    if(self.btn == nil){
        self.btn = [[UIButton alloc]init];
        self.btn.frame = FRAME(WIDTH - 110, 15, 100, 30);
        [self addSubview:self.btn];
        self.btn.layer.cornerRadius = 2;
        self.btn.layer.masksToBounds = YES;
        self.btn.layer.borderColor = [UIColor colorWithRed:250/255.0 green:92/255.0 blue:101/255.0 alpha:1].CGColor;
        self.btn.layer.borderWidth = 1;
        [self.btn setTitleColor:[UIColor colorWithRed:250/255.0 green:92/255.0 blue:101/255.0 alpha:1]  forState:UIControlStateNormal];
        self.btn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    [self.btn setTitle:@"申请退款" forState:UIControlStateNormal];
}


@end
