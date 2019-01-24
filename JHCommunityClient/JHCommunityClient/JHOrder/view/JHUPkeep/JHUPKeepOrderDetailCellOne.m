//
//  JHUPKeepOrderDetailCellOne.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHUPKeepOrderDetailCellOne.h"

@implementation JHUPKeepOrderDetailCellOne
{
    UILabel * label_state;//显示订单状态的
    UILabel * label_line;//显示分割线的
    
}
-(void)setModel:(OrderModel *)model{
    _model = model;
    if(label_state == nil){
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(15, 10, WIDTH - 120, 40);
        label_state.numberOfLines = 2;
        label_state.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label_state];
    }
    NSString * string = @"订单完成(等待评价)";
    NSRange range = [string rangeOfString:@"订单完成"];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:string];
    [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:range];
    label_state.text = string;
    label_state.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    label_state.font = [UIFont systemFontOfSize:13];
    label_state.attributedText = attributed;
    if(label_line == nil){
        label_line = [[UILabel alloc]init];
        label_line.frame = FRAME(0, 59.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    //创建按钮
    if (self.btn == nil) {
        self.btn = [[UIButton alloc]init];
        self.btn.frame = FRAME(WIDTH - 115, 10, 100, 40);
        self.btn.layer.cornerRadius = 2;
        self.btn.clipsToBounds = YES;
        [self addSubview:self.btn];
        self.btn.backgroundColor = [UIColor colorWithRed:245/255.0 green:60/255.0 blue:70/255.0 alpha:1];
    }
    [self.btn setTitle:@"去评价" forState:UIControlStateNormal];
}

@end
