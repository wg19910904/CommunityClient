//
//  JHRunTableViewCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHRunTableViewCell.h"

@implementation JHRunTableViewCell
{
     UIView * view_lineOne;//头部的分割线
    UIView * view;
    UILabel * label_type;//显示订单类型的
    UILabel * label_time;//在待支付的状态下的显示时间的
    UILabel * label_state;//显示状态的
    UIImageView * imageViewOne;
    UIImageView * imageViewTwo;
    UIImageView * imageViewThree;
    UILabel * label_shop;//显示购买的商品
    UILabel * label_address;//显示购买地址的
    UILabel * label_phone;//显示电话号码的
    UILabel *label_order;
}

-(void)setModel:(JHRunModel *)model{
    _model = model;
    if(view_lineOne == nil){
        //创建头部的分割线
        view_lineOne = [[UIView alloc]init];
        view_lineOne.frame = FRAME(0, 0, WIDTH, 0.5);
        view_lineOne.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:view_lineOne];
        //创建第二根分割线
        UIView * view_LineTwo = [[UIView alloc]init];
        view_LineTwo.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        view_LineTwo.frame = FRAME(0, 39.5, WIDTH, 0.5);
        [self addSubview:view_LineTwo];
        //创建第三根分割线
        UIView * view_LineThree = [[UIView alloc]init];
        view_LineThree.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        view_LineThree.frame = FRAME(0, 179.5, WIDTH, 0.5);
        [self addSubview:view_LineThree];
        //创建第四根分割线
        UIView * view_LineFour = [[UIView alloc]init];
        view_LineFour.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        view_LineFour.frame = FRAME(0, 224.5, WIDTH, 0.5);
        [self addSubview:view_LineFour];
        //创建单元格之间的空隙
        view  = [[UIView alloc]init];
        view.frame = FRAME(0, 225, WIDTH, 15);
        [self addSubview:view];
    }
    view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    //创建显示跑腿类型的
    if(label_type == nil){
        label_type =[[UILabel alloc]init];
        label_type.frame = FRAME(15, 10, 50, 20);
        label_type.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_type.font = [UIFont systemFontOfSize:16];
        [self addSubview:label_type];
    }
        label_type.text = NSLocalizedString(@"帮我送", nil);
    //创建去支付还剩多少时间的
    if(label_time == nil){
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(70, 10, 100, 20);
        label_time.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_time.font = [UIFont systemFontOfSize:14];
        [self addSubview:label_time];
    }
    if ([model.order_status_label isEqualToString:NSLocalizedString(@"待支付", nil)]) {
        label_time.hidden = NO;
    }else {
        label_time.hidden = YES;
    }
    label_time.text = @"";
    //创建显示订单的状态的
    if(label_state == nil){
        label_state = [[UILabel alloc]init];
        label_state.textColor = THEME_COLOR;
        label_state.frame = FRAME(WIDTH - 90, 10, 80, 20);
        label_state.textAlignment = NSTextAlignmentRight;
        label_state.font = [UIFont systemFontOfSize:16];
        [self addSubview:label_state];
    }
    label_state.text = model.order_status_label;
    //创建商品和地址前面的那两张图片
    if(imageViewOne == nil){
        imageViewOne = [[UIImageView alloc]init];
        imageViewOne.frame = FRAME(15, 50, 20, 20);
        [self addSubview:imageViewOne];
        imageViewOne.image = [UIImage imageNamed:@"bag"];
        //imageViewOne.backgroundColor = [UIColor redColor];
        imageViewTwo = [[UIImageView alloc]init];
        imageViewTwo.frame = FRAME(17.5, 85, 15, 20);
        imageViewTwo.image = [UIImage imageNamed:@"zuobaio2"];
        //imageViewTwo.backgroundColor = [UIColor redColor];
        [self addSubview:imageViewTwo];
        imageViewThree = [[UIImageView alloc]init];
        imageViewThree.frame = FRAME(15, 145, 20, 20);
        [self addSubview:imageViewThree];
        imageViewThree.image = [UIImage imageNamed:@"phone03"];
    }
    //显示商品的
    if(label_shop == nil){
        label_shop = [[UILabel alloc]init];
        label_shop.frame = FRAME(40, 50,  WIDTH - 70, 20);
        label_time.adjustsFontSizeToFitWidth = YES;
        label_shop.font = [UIFont systemFontOfSize:14];
        label_shop.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_shop];
    }
    label_shop.text = [NSString stringWithFormat:NSLocalizedString(@"要求及描述:%@", nil),model.intro];
    //显示地理位置的
    if(label_address == nil){
        label_address = [[UILabel alloc]init];
        label_address.frame = FRAME(40, 76, WIDTH - 70, 60);
        label_address.numberOfLines = 3;
        label_address.adjustsFontSizeToFitWidth = YES;
        label_address.font = [UIFont systemFontOfSize:14];
        label_address.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_address];
    }
    label_address.text = [NSString stringWithFormat:NSLocalizedString(@"收货地址:\n%@", nil),model.o_addr];
    if(label_phone == nil){
        label_phone = [[UILabel alloc]init];
        label_phone.frame = FRAME(40, 145, WIDTH/2+30, 20);
        label_phone.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_phone.font = [UIFont systemFontOfSize:14];
        [self addSubview:label_phone];
    }
    label_phone.text = [NSString stringWithFormat:NSLocalizedString(@"收货人电话:%@****%@", nil),[model.mobile substringToIndex:3],[model.mobile substringWithRange:NSMakeRange(7, 4)]];
    //显示订单号的
    if(label_order == nil){
        label_order = [[UILabel alloc]init];
        label_order.frame = FRAME(15, 185, WIDTH/2, 30);
        label_order.font = FONT(14);
        label_order.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_order];
    }
    label_order.text = [NSString stringWithFormat:NSLocalizedString(@"订单号:%@", nil),model.order_id];
    //显示去支付的按钮
    if(self.btn_pay == nil){
        self.btn_pay = [[JHOrderBtn alloc]init];
        self.btn_pay.layer.cornerRadius = 2;
        self.btn_pay.layer.masksToBounds = YES;
        self.btn_pay.frame = FRAME(WIDTH - 90,185,80, 30);
        self.btn_pay.titleLabel.font = [UIFont systemFontOfSize:16];
        self.btn_pay.backgroundColor = THEME_COLOR;
        self.btn_pay.adjustsImageWhenDisabled = YES;
        [self addSubview:self.btn_pay];
    }
    if([model.order_status intValue] == 0 && [model.pay_status intValue] == 0){
        [self.btn_pay setTitle:NSLocalizedString(@"去支付", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = THEME_COLOR;
        
    }else if ([model.order_status intValue] == 0){
        [self.btn_pay setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = THEME_COLOR;
        
    }else if([model.order_status integerValue] == 1||[model.order_status integerValue] == 2){
        [self.btn_pay setTitle:NSLocalizedString(@"等待服务", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }else if ([model.order_status integerValue]== 4){
        [self.btn_pay setTitle:NSLocalizedString(@"确认完成", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = THEME_COLOR;
    }
    else if ([model.order_status intValue] == 8 && [model.comment_status intValue] == 0){
        [self.btn_pay setTitle:NSLocalizedString(@"去评价", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = THEME_COLOR;
    }else if([model.order_status intValue] == 8 && [model.comment_status intValue] == 1){
        [self.btn_pay setTitle:NSLocalizedString(@"已评价", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        ;
    }else if ([model.order_status integerValue] == -1){
        [self.btn_pay setTitle:NSLocalizedString(@"已取消", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    else if ([model.order_status intValue] == 3){
        [self.btn_pay setTitle:NSLocalizedString(@"服务中", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }else{
        self.btn_pay.backgroundColor = [UIColor clearColor];
        [self.btn_pay setTitle:@"" forState:UIControlStateNormal];
    }



    
    //创建取消订单的按纽
    if (self.btn_cancel == nil) {
        self.btn_cancel = [[JHOrderBtn alloc]init];
        self.btn_cancel.frame = FRAME(WIDTH - 180, 185, 80, 30);
        self.btn_cancel.layer.cornerRadius = 2;
        self.clipsToBounds = YES;
        [self.btn_cancel setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        [self.btn_cancel setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        self.btn_cancel.layer.borderWidth = 1;
        self.btn_cancel.layer.borderColor = THEME_COLOR.CGColor;
        self.btn_cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.btn_cancel];
    }
    if([model.order_status intValue] == 0 && [model.pay_status intValue] == 0){
        self.btn_cancel.hidden = NO;
    }else{
        self.btn_cancel.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //self.btn.backgroundColor = THEME_COLOR;
    [self setModel:_model];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    //self.btn.backgroundColor = THEME_COLOR;
    [self setModel:_model];
}

@end
