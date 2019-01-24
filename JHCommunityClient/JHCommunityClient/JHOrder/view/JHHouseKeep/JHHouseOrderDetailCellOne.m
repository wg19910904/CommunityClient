//
//  JHHouseOrderDetailCellOne.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHouseOrderDetailCellOne.h"

@implementation JHHouseOrderDetailCellOne
{
    UILabel * label_state;//显示订单状态的
    UIView * label_line;//显示分割线的
    
}

-(void)setModel:(JHHouseProgressModel *)model{
    _model = model;
    if(label_state == nil){
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(15, 10, WIDTH - 120, 40);
        label_state.numberOfLines = 2;
        label_state.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label_state];
    }
    NSString * string =[NSString stringWithFormat:@"%@(%@)\n%@",model.order_status_label,model.dateline,model.order_status_warning];
    NSRange range = [string rangeOfString:model.order_status_label];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:string];
    [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:range];
    label_state.text = string;
    label_state.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    label_state.font = [UIFont systemFontOfSize:13];
    label_state.attributedText = attributed;
    if(label_line == nil){
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 59.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    //创建按钮
    if(self.btn == nil){
        self.btn = [[UIButton alloc]init];
        self.btn.frame = FRAME(WIDTH - 115, 10, 100, 40);
        self.btn.layer.cornerRadius = 2;
        self.btn.layer.masksToBounds = YES;
        self.btn.layer.borderColor = [UIColor orangeColor].CGColor;
        self.btn.layer.borderWidth = 1;
        [self.btn setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:self.btn];
    }
    if([model.order_status intValue] == 0 && [model.pay_status intValue] == 0){
        self.btn.hidden = NO;
    }else{
        self.btn.hidden = YES;
    }
}
@end
