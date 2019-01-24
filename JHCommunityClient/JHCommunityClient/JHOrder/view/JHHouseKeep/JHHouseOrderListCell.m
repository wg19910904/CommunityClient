//
//  JHHouseOrderListCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/15.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHouseOrderListCell.h"
@implementation JHHouseOrderListCell
{
    UIView * label_line;//创建分割线
    UILabel * label_type;//显示订单种类的
    UIView * label;//创建中间的分割间隙
    UIImageView * imageV;//创建显示照片的
    UIImageView * image_time;//创建时间的小图标
    UIImageView * image_address;//创建地址的小图标
    UILabel * label_time;//显示时间的
    UILabel * label_address;//显示地址的
    UILabel * label_state;//显示订单状态的
    UILabel * label_order;//显示订单号的
}

-(void)setModel:(JHHouseModel *)model{
    _model = model;
    if(label_line == nil){
      //创建第一根分割线
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 0, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
        //创建第二根分割线
        UIView * label_lineTwo = [[UIView alloc]init];
        label_lineTwo.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_lineTwo.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_lineTwo];
        //创建第三个分割线
        UIView * label_lineThree = [[UIView alloc]init];
        label_lineThree.frame = FRAME(0, 139.5, WIDTH, 0.5);
        label_lineThree.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_lineThree];
        //创建第四根分割线
        UIView * label_four = [[UIView alloc]init];
        label_four.frame = FRAME(0, 184.5, WIDTH, 0.5);
        label_four.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_four];
        //创建灰色的间隙
        label = [[UIView alloc]init];
        label.frame = FRAME(0, 185, WIDTH, 15);
        [self addSubview:label];
    }
    label.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    //创建显示照片的
    if(imageV == nil){
        imageV = [[UIImageView alloc]init];
        imageV.frame = FRAME(15, 55, 70, 70);
        [self addSubview:imageV];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.cate_icon];
    [imageV sd_image:[NSURL URLWithString:url] plimage:[UIImage imageNamed:@"supermarketproduct"]];
    //创建时间的小图标
    if(image_time == nil){
        image_time = [[UIImageView alloc]init];
        image_time.frame = FRAME(100, 60, 20, 20);
        [self addSubview:image_time];
    }
    image_time.image = [UIImage imageNamed:@"time"];
    //创建地址的小图标
    if (image_address == nil) {
        image_address = [[UIImageView alloc]init];
        image_address.frame = FRAME(102, 100, 15, 20);
        [self addSubview:image_address];
    }
    image_address.image = [UIImage imageNamed:@"zuobaio2"];
    //显示时间的
    if(label_time == nil){
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(130, 60, WIDTH/2, 20);
        label_time.font = [UIFont systemFontOfSize:14];
        label_time.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:label_time];
    }
    label_time.text = [self getTimeWithDataLine:model.dateline];
    //显示地址的
    if (label_address == nil) {
        label_address = [[UILabel alloc]init];
        label_address.frame = FRAME(130, 90, WIDTH - 10- 130, 40);
        label_address.numberOfLines = 2;
        label_address.font = [UIFont systemFontOfSize:14];
        label_address.adjustsFontSizeToFitWidth = YES;
        label_address.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:label_address];
    }
       label_address.text = model.addr;
    //显示订单类别的
    if(label_type == nil){
        label_type = [[UILabel alloc]init];
        label_type.frame = FRAME(15, 10, WIDTH/2, 20);
        label_type.font = [UIFont systemFontOfSize:16];
        label_type.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        [self addSubview:label_type];
    }
        label_type.text = model.cate_title;
    //显示订单状态的
    if(label_state == nil){
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(WIDTH - 15 - 80, 10, 80, 20);
        label_state.textColor = THEME_COLOR;
        label_state.font = [UIFont systemFontOfSize:16];
        label_state.textAlignment = NSTextAlignmentRight;
        [self addSubview:label_state];
    }
    label_state.text = model.order_status_label;
    //显示订单号的
    if(label_order == nil){
        label_order = [[UILabel alloc]init];
        label_order.frame = FRAME(15, 147.5, WIDTH/2, 30);
        label_order.font = FONT(14);
        label_order.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label_order];
    }
    label_order.text = [NSString stringWithFormat:NSLocalizedString(@"订单号:%@", nil),model.order_id];
    //显示支付或者评价按钮
    if(self.btn_pay == nil){
        self.btn_pay = [[UIButton alloc]init];
        self.btn_pay.frame = FRAME(WIDTH - 10 - 80, 147.5,80 , 30);
        self.btn_pay.layer.cornerRadius = 2;
        self.btn_pay.layer.masksToBounds = YES;
        self.btn_pay.titleLabel.font = [UIFont systemFontOfSize:15];
        self.btn_pay.backgroundColor = THEME_COLOR;
        self.btn_pay.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.btn_pay];
    }
  
    if([model.pay_status intValue] == 0&&[model.order_status integerValue] != 5 && [model.order_status integerValue] != -1){
        [self.btn_pay setTitle:NSLocalizedString(@"去支付", nil) forState:UIControlStateNormal];
         self.btn_pay.backgroundColor = THEME_COLOR;
        
    }else if ([model.order_status intValue] == 1&&[model.staff_id integerValue]>0){
        [self.btn_pay setTitle:NSLocalizedString(@"等待服务", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    else if ([model.order_status intValue] == 0){
        [self.btn_pay setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = THEME_COLOR;
        
    }else if ([model.order_status intValue] == 2){
        [self.btn_pay setTitle:NSLocalizedString(@"等待服务", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    else if ([model.order_status intValue] == 8 && [model.comment_status intValue] == 0){
        [self.btn_pay setTitle:NSLocalizedString(@"去评价", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = THEME_COLOR;
    }else if([model.order_status intValue] == 8 && [model.comment_status intValue] == 1){
        [self.btn_pay setTitle:NSLocalizedString(@"已评价", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        ;
    }else if ([model.order_status intValue] == 5 && [model.jiesuan_price floatValue] != [self totalAmount]){
        [self.btn_pay setTitle:NSLocalizedString(@"补差价", nil) forState:UIControlStateNormal];
          self.btn_pay.backgroundColor = THEME_COLOR;
    }else if ([model.order_status integerValue] == 5 && [model.jiesuan_price floatValue] == [self totalAmount]){
        [self.btn_pay setTitle:NSLocalizedString(@"确认完成", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = THEME_COLOR;
    }
    else if ([model.order_status intValue] == 3){
        [self.btn_pay setTitle:NSLocalizedString(@"服务中", nil) forState:UIControlStateNormal];
         self.btn_pay.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }else if ([model.order_status intValue] == 4){
        [self.btn_pay setTitle:NSLocalizedString(@"待结算", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    else if ([model.order_status intValue] == -1){
        [self.btn_pay setTitle:NSLocalizedString(@"已取消", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    else if([model.order_status integerValue] == 1&&[model.staff_id integerValue] > 0){
        [self.btn_pay setTitle:NSLocalizedString(@"等待服务", nil) forState:UIControlStateNormal];
        self.btn_pay.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    else{
        self.btn_pay.backgroundColor = [UIColor clearColor];
        [self.btn_pay setTitle:@"" forState:UIControlStateNormal];
    }
    //显示取消订单还是删除订单
    if (self.btn_cancel == nil) {
        self.btn_cancel = [[UIButton alloc]init];
        self.btn_cancel.frame = FRAME(WIDTH - 180, 147.5,80 , 30);
        self.btn_cancel.layer.cornerRadius = 2;
        self.btn_cancel.layer.masksToBounds = YES;
        self.btn_cancel.layer.borderColor = THEME_COLOR.CGColor;
        self.btn_cancel.layer.borderWidth = 1;
        self.btn_cancel.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btn_cancel setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        [self addSubview:self.btn_cancel];

    }
    if([model.pay_status intValue] == 0&&[model.order_status integerValue] != 5 && [model.order_status integerValue] != -1){
        self.btn_cancel.hidden = NO;
    }else{
        self.btn_cancel.hidden = YES;
    }
    [self.btn_cancel setTitleColor:THEME_COLOR forState:UIControlStateNormal];
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    [self setModel:self.model];
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    [self setModel:self.model];
}
#pragma mark - 这是时间戳的转化方法
-(NSString *)getTimeWithDataLine:(NSString *)dateLine{
    NSInteger num = [dateLine integerValue];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}
-(float)totalAmount{
    return _model.amount.floatValue + _model.hongbao.floatValue;
}
@end
