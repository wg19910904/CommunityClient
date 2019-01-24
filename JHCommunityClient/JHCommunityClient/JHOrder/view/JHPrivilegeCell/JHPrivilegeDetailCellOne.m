//
//  JHPrivilegeDetailCellOne.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPrivilegeDetailCellOne.h"

@implementation JHPrivilegeDetailCellOne
{
    UILabel * label_state;//显示订单状态的
}

-(void)setModel:(JHPrivilegeDetailModel *)model{
    _model = model;
   self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(label_state == nil){
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(10, 5, 60, 30);
        label_state.textColor = THEME_COLOR;
        label_state.font = [UIFont systemFontOfSize:14];
        [self addSubview:label_state];
        //创建一个分割线
        UIView * label = [[UIView alloc]init];
        label.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label];
    }
    if ([model.order_status intValue] == 8 && [model.comment_status intValue] == 0) {
        label_state.text = NSLocalizedString(@"待评价", nil);
    }else if([model.order_status intValue] == 8 && [model.comment_status intValue] == 1){
        label_state.text = NSLocalizedString(@"已评价", nil);
    }else if([model.order_status intValue] == 0 && [model.pay_status intValue] == 0){
        label_state.text = NSLocalizedString(@"未支付", nil);
    }
    else{
        label_state.text = NSLocalizedString(@"已支付", nil);
    }
    if(self.btn == nil){
        self.btn = [[UIButton alloc]init];
        self.btn.frame = FRAME(WIDTH - 70, 5, 60, 30);
        self.btn.backgroundColor = [UIColor orangeColor];
        [self.btn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        self.btn.layer.cornerRadius = 3;
        self.btn.layer.masksToBounds = YES;
        [self addSubview:self.btn];
        [self.btn setTitle:NSLocalizedString(@"评价", nil) forState:UIControlStateNormal];
        
    }
    if ([model.order_status isEqualToString:@"8"]&&[model.comment_status isEqualToString:@"0"]) {
        self.btn.hidden = NO;
    }else{
        self.btn.hidden = YES;
    }
    
}
@end
