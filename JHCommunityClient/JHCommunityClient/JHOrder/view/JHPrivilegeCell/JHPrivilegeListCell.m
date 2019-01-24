//
//  JHPrivilegeListCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/5/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPrivilegeListCell.h"
#import <Masonry.h>
#import "UIImageView+NetStatus.h"
@implementation JHPrivilegeListCell
{
    UIView * label_lineOne;//创建的第一根分割线
    UIView * label_lineTwo;//创建的第二根分割线
    UIView * label_lineThree;//创建的第三根分割线
    UIView * label_lineFour;//创建的第四根分割线
    UIImageView * imageView_head;//创建优惠的标示
    UILabel * label_title;//创建显示标题的label
    UILabel * label_state;//显示状态的label
    UIImageView * imageView_icon;//展示图标的
    UILabel * label_expense;//消费
    UILabel * label_pay;//实付
    UILabel * label_expenseMoney;//消费金额
    UILabel * label_payMoney;//实际支付金额
    UILabel * label_time;//显示下单时间的
    UIView * bj_view;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    [self setModel:self.model];
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    [self setModel:self.model];
}
-(void)setModel:(JHPrivilegeListModel *)model{
    _model = model;
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (bj_view == nil) {
        bj_view = [[UIView alloc]init];
        bj_view.backgroundColor = [UIColor whiteColor];
        [self addSubview:bj_view];
        [bj_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.right.offset(-0);
            make.bottom.offset(-10);
        }];
    }
    if(label_lineOne == nil){
        //创建第一根分割线
        label_lineOne = [[UIView alloc]init];
        label_lineOne.frame = FRAME(0, 0, WIDTH, 0.5);
        label_lineOne.backgroundColor= [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_lineOne];
        //创建第二根分割线
        label_lineTwo = [[UIView alloc]init];
        label_lineTwo.frame = FRAME(0, 32.5, WIDTH, 0.5);
        label_lineTwo.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_lineTwo];
        //创建第三根分割线
        label_lineThree = [[UIView alloc]init];
        label_lineThree.frame = FRAME(0, 112.5, WIDTH, 0.5);
        label_lineThree.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_lineThree];
        //创建第四根分割线
        label_lineFour = [[UIView alloc]init];
        label_lineFour.frame = FRAME(0, 159.5, WIDTH, 0.5);
        label_lineFour.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_lineFour];
        //创建优惠的标示
        imageView_head = [[UIImageView alloc]init];
        imageView_head.frame = FRAME(10, 5, 20, 20);
        imageView_head.image = [UIImage imageNamed:@"hui"];
        [bj_view addSubview:imageView_head];
        //创建显示标题的label
        label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(35, 5, WIDTH - 35 - 100, 20);
        label_title.font = [UIFont systemFontOfSize:16];
        label_title.textColor = HEX(@"666666", 2);
        label_title.adjustsFontSizeToFitWidth = YES;
        [bj_view addSubview:label_title];
    }
         label_title.text = model.title;
    //显示状态的按钮
    if (label_state == nil) {
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(WIDTH - 90, 5, 80, 20);
        label_state.textColor = THEME_COLOR;
        label_state.textAlignment = NSTextAlignmentRight;
        label_state.font = [UIFont systemFontOfSize:15];
        label_state.adjustsFontSizeToFitWidth = YES;
        [bj_view addSubview:label_state];
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
    //展示图标的
    if (imageView_icon == nil) {
        imageView_icon = [[UIImageView alloc]init];
        imageView_icon.frame = FRAME(10, 43, 60, 60);
        [bj_view addSubview:imageView_icon];
     }
     [imageView_icon sd_image:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.photo]] plimage:[UIImage imageNamed:@"commondefault"]];
    //展示消费和实付的label
    if(label_expense == nil){
        label_expense = [[UILabel alloc]init];
        label_expense.frame = FRAME(85, 45, 40, 20);
        label_expense.font = [UIFont systemFontOfSize:15];
        label_expense.text = NSLocalizedString(@"消费", nil);
        label_expense.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [bj_view addSubview:label_expense];
        label_pay = [[UILabel alloc]init];
        label_pay.frame = FRAME(85, 80, 40, 20);
        label_pay.font = [UIFont systemFontOfSize:15];
        label_pay.text = NSLocalizedString(@"实付", nil);
        label_pay.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [bj_view addSubview:label_pay];
    }
    //展示消费和实付
    if(label_expenseMoney == nil){
        label_expenseMoney = [[UILabel alloc]init];
        label_expenseMoney.frame = FRAME(120, 45, 100, 20);
        label_expenseMoney.font = [UIFont systemFontOfSize:15];
        label_expenseMoney.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        [bj_view addSubview:label_expenseMoney];
        label_payMoney = [[UILabel alloc]init];
        label_payMoney.frame = FRAME(120, 80, 100, 20);
        label_payMoney.font = [UIFont systemFontOfSize:15];
        label_payMoney.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        [bj_view addSubview:label_payMoney];
    }
    label_expenseMoney.text = [NSString stringWithFormat:@"¥ %.1f",[model.total_price floatValue]];
    label_payMoney.text = [NSString stringWithFormat:@"¥ %.1f",[model.amount floatValue]+[model.money floatValue]];
    if(label_time == nil){
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(10, 118, WIDTH - 160, 40);
        label_time.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_time.font = [UIFont systemFontOfSize:13];
        label_time.numberOfLines = 0;
        label_time.adjustsFontSizeToFitWidth = YES;
        [bj_view addSubview:label_time];
    }
    label_time.text = [NSString stringWithFormat:NSLocalizedString(@"订单号:%@\n下单时间:%@", nil),model.order_id,[self returnTimeWithDateline:model.dateline]];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:label_time.text];
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
    [paragraph setLineSpacing:5];
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, label_time.text.length)];
    label_time.attributedText = attribute;

    //创建评价和取消订单的按钮
    if(self.btn_evalute == nil){
        self.btn_evalute = [[UIButton alloc]init];
        self.btn_evalute.frame = FRAME(WIDTH - 90,125,80,30);
        self.btn_evalute.layer.cornerRadius = 3;
        self.btn_evalute.clipsToBounds = YES;
        [self.btn_evalute setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn_evalute.titleLabel.font = [UIFont systemFontOfSize:15];
        self.btn_evalute.titleLabel.adjustsFontSizeToFitWidth = YES;
        [bj_view addSubview:self.btn_evalute];
        self.btn_cancel = [[UIButton alloc]init];
        self.btn_cancel.frame = FRAME(WIDTH - 180,125,80,30);
        self.btn_cancel.layer.cornerRadius = 3;
        self.btn_cancel.clipsToBounds = YES;
        self.btn_cancel.layer.borderColor = THEME_COLOR.CGColor;
        self.btn_cancel.layer.borderWidth = 1;
        [self.btn_cancel setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        self.btn_cancel.backgroundColor = [UIColor whiteColor];
        self.btn_cancel.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btn_cancel setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        [bj_view addSubview:self.btn_cancel];
    }
    self.btn_evalute.backgroundColor = THEME_COLOR;
    self.btn_cancel.hidden = YES;
//    if([model.order_status intValue] == 0 && [model.pay_status intValue] == 0){
//        self.btn_cancel.hidden = NO;
//    }else{
//        self.btn_cancel.hidden = YES;
//    }
    if ([model.order_status intValue] == 8 && [model.comment_status intValue] == 0) {
        self.btn_evalute.hidden = NO;
        [self.btn_evalute setTitle:NSLocalizedString(@"去评价", nil) forState:UIControlStateNormal];
        self.btn_evalute.backgroundColor = THEME_COLOR;
    }else if ([model.order_status intValue] == 8 && [model.comment_status intValue] == 1){
        self.btn_evalute.hidden = NO;
        [self.btn_evalute setTitle:NSLocalizedString(@"已评价", nil) forState:UIControlStateNormal];
         self.btn_evalute.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        ;

    }else{
        self.btn_evalute.hidden = YES;
    }
//    if([model.order_status intValue] == 0 && [model.pay_status intValue] == 0){
//        [self.btn_evalute setTitle:NSLocalizedString(@"去支付", nil) forState:UIControlStateNormal];
//        self.btn_evalute.backgroundColor = THEME_COLOR;
//        
//    }else if ([model.order_status intValue] == 0){
//        [self.btn_evalute setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
//        self.btn_evalute.backgroundColor = THEME_COLOR;
//        
//    }else if ([model.order_status intValue] == 8 && [model.comment_status intValue] == 0){
//        [self.btn_evalute setTitle:NSLocalizedString(@"去评价", nil) forState:UIControlStateNormal];
//        self.btn_evalute.backgroundColor = THEME_COLOR;
//    }else if([model.order_status intValue] == 8 && [model.comment_status intValue] == 1){
//        [self.btn_evalute setTitle:NSLocalizedString(@"已评价", nil) forState:UIControlStateNormal];
//        self.btn_evalute.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
//        ;
//    }else if ([model.order_status intValue] == -1){
//        [self.btn_evalute setTitle:NSLocalizedString(@"订单已取消", nil) forState:UIControlStateNormal];
//        self.btn_evalute.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
//        ;
//    }
//    else if([model.order_status intValue] == 5){
//        [self.btn_evalute setTitle:NSLocalizedString(@"待消费", nil) forState:UIControlStateNormal];
//        self.btn_evalute.backgroundColor =[UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
//    }else{
//        self.btn_evalute.backgroundColor = [UIColor clearColor];
//        [self.btn_evalute setTitle:@"" forState:UIControlStateNormal];
//    }
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
