//
//  JHPrivilegeDetailCellThree.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPrivilegeDetailCellThree.h"

@implementation JHPrivilegeDetailCellThree
{
    UILabel * label;//显示订单详情四个字的
    UILabel * label_number;//显示订单号的
    UILabel * label_expense;//显示消费的金额
    UILabel * label_money;//显示实际支付的金额
    UILabel * label_you;//显示优惠方案
    UILabel * label_time;//显示买单时间
    UILabel * label_phone;//显示手机号码的
}

-(void)setModel:(JHPrivilegeDetailModel *)model{
     _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(label == nil){
        label = [[UILabel alloc]init];
        label.frame = FRAME(10, 5, WIDTH - 20, 20);
        label.text = NSLocalizedString(@"订单详情", nil);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        [self addSubview:label];
        //这是第一根分割线
        UIView * label_one = [[UIView alloc]init];
        label_one.frame = FRAME(0, 0, WIDTH, 0.5);
        label_one.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_one];
        //这是第二根分割线
        UIView * label_two = [[UIView alloc]init];
        label_two.frame = FRAME(0, 29.5, WIDTH, 0.5);
        label_two.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_two];
        //这是第三根分割线
        UIView * label_three = [[UIView alloc]init];
        label_three.frame = FRAME(0, 124.5, WIDTH, 0.5);
        label_three.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_three];
        //这是第四根分割线
        UIView * label_four = [[UIView alloc]init];
        label_four.frame = FRAME(0, 179.5, WIDTH, 0.5);
        label_four.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_four];
        //显示订单号的
        label_number = [[UILabel alloc]init];
        label_number.frame = FRAME(10, 35, WIDTH - 10, 20);
        label_number.font = [UIFont systemFontOfSize:13];
        label_number.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_number];
        //显示消费金额的
        label_expense = [[UILabel alloc]init];
        label_expense.frame = FRAME(10, 55, WIDTH - 10, 20);
        label_expense.font = [UIFont systemFontOfSize:13];
        label_expense.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_expense];
        //显示实际支付的
        label_money = [[UILabel alloc]init];
        label_money.frame = FRAME(10, 77, WIDTH - 10, 20);
        label_money.font = [UIFont systemFontOfSize:13];
        label_money.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_money];
        //显示优惠方案的
        label_you = [[UILabel alloc]init];
        label_you.frame = FRAME(10, 100, WIDTH - 10, 20);
        label_you.font = [UIFont systemFontOfSize:13];
        label_you.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_you];
        //显示 买单时间的
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(10, 130, WIDTH - 10, 20);
        label_time.font = [UIFont systemFontOfSize:13];
        label_time.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_time];
        //显示手机号码的
        label_phone = [[UILabel alloc]init];
        label_phone.frame = FRAME(10, 150, WIDTH - 10, 20);
        label_phone.font = [UIFont systemFontOfSize:13];
        label_phone.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_phone];

        
    }
    label_number.text = [NSString stringWithFormat:NSLocalizedString(@"订单号:%@", nil),model.order_id];
    label_expense.text = [NSString stringWithFormat:NSLocalizedString(@"消费: ¥%g", nil),[model.total_price floatValue]];
    label_money.text = [NSString stringWithFormat:NSLocalizedString(@"实付: ¥%g", nil),[model.amount floatValue] + [model.money floatValue]];
    label_you.text = [NSString stringWithFormat:NSLocalizedString(@"优惠方案:商家优惠 ¥%g", nil),[model.order_youhui floatValue]];
    label_time.text = [NSString stringWithFormat:NSLocalizedString(@"买单时间: %@", nil),[self returnTimeWithDateline:model.dateline]];
    label_phone.text = [NSString stringWithFormat:NSLocalizedString(@"手机号码: %@", nil),model.phone];
}
#pragma mark - 这是时间戳转化的方法
-(NSString *)returnTimeWithDateline:(NSString *)dateline{
    NSInteger num = [dateline integerValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}

@end
