//
//  TakeawayOrderDetailCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "TakeawayOrderDetailCell.h"

@implementation TakeawayOrderDetailCell
{
    UILabel * label_state;//创建显示订单进度的
    UIView * label_line;//创建分割线
    UILabel * label_time;//显示预计送达的时间的
}

-(void)setModel:(JHTakeawayDetailModel *)model{
    _model = model;
    if(label_state == nil){
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(10, 10, WIDTH/2+40, 40);
        label_state.numberOfLines = 2;
        label_state.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label_state];
    }
    NSString * string = [NSString stringWithFormat:@"%@(%@)\n%@",model.order_status_label,model.dateline,model.order_status_warning];
    NSRange range = [string rangeOfString:model.order_status_label];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:string];
    [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:range];
    label_state.text = string;
    label_state.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    label_state.font = [UIFont systemFontOfSize:13];
    label_state.attributedText = attributed;
    
    if(label_line == nil){
        label_line = [[UIView alloc]init];
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        label_line.frame = FRAME(0, 59.5, WIDTH, 0.5);
        [self addSubview:label_line];
    }
//    if(label_time == nil){
//        label_time = [[UILabel alloc]init];
//        label_time.frame = FRAME(10, 35, WIDTH/2, 20);
//        [self addSubview:label_time];
//        label_time.font = [UIFont systemFontOfSize:13];
//        label_time.textColor = [UIColor colorWithWhite:0.6 alpha:1];
//    }
//    label_time.text = NSLocalizedString(@"预计送达:11:48 等待:20分钟", nil);
    if(self.btn_backOrder == nil){
        self.btn_backOrder = [[UIButton alloc]init];
        self.btn_backOrder.frame = FRAME(WIDTH - 110, 15, 100, 30);
        [self addSubview:self.btn_backOrder];
        self.btn_backOrder.layer.cornerRadius = 2;
        self.btn_backOrder.layer.masksToBounds = YES;
        self.btn_backOrder.layer.borderColor = [UIColor colorWithRed:250/255.0 green:92/255.0 blue:101/255.0 alpha:1].CGColor;
        self.btn_backOrder.layer.borderWidth = 1;
        [self.btn_backOrder setTitleColor:[UIColor colorWithRed:250/255.0 green:92/255.0 blue:101/255.0 alpha:1]  forState:UIControlStateNormal];
        self.btn_backOrder.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    [self.btn_backOrder setTitle:NSLocalizedString(@"申请退款", nil) forState:UIControlStateNormal];
//    if([model.order_status intValue] == -1 && [model.pay_status intValue] == 1){
//        self.btn_backOrder.hidden = NO;
//    }
//    else{
//        self.btn_backOrder.hidden = YES;
//    }
    self.btn_backOrder.hidden = YES;

}
@end
