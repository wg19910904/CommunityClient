//
//  JHUPKeepOrderListCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/15.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHUPKeepOrderListCell.h"

@implementation JHUPKeepOrderListCell
{
    UILabel * label_line;//创建分割线
    UILabel * label_type;//显示订单种类的
    UILabel * label;//创建中间的分割间隙
    UIImageView * imageV;//创建显示照片的
    UIImageView * image_time;//创建时间的小图标
    UIImageView * image_address;//创建地址的小图标
    UILabel * label_time;//显示时间的
    UILabel * label_address;//显示地址的
    UILabel * label_state;//显示订单状态的

}
- (void)awakeFromNib {
}

-(void)setModel:(OrderModel *)model{
    _model = model;
    if(label_line == nil){
        //创建第一根分割线
        label_line = [[UILabel alloc]init];
        label_line.frame = FRAME(0, 0, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
        //创建第二根分割线
        UILabel * label_lineTwo = [[UILabel alloc]init];
        label_lineTwo.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_lineTwo.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_lineTwo];
        //创建第三个分割线
        UILabel * label_lineThree = [[UILabel alloc]init];
        label_lineThree.frame = FRAME(0, 139.5, WIDTH, 0.5);
        label_lineThree.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_lineThree];
        //创建第四根分割线
        UILabel * label_four = [[UILabel alloc]init];
        label_four.frame = FRAME(0, 184.5, WIDTH, 0.5);
        label_four.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_four];
        //创建灰色的间隙
        label = [[UILabel alloc]init];
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
    imageV.image = [UIImage imageNamed:@"shuilongtou"];
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
    label_time.text = @"2016-9-15 12:00";
    //显示地址的
    if (label_address == nil) {
        label_address = [[UILabel alloc]init];
        label_address.frame = FRAME(130, 100, WIDTH - 10- 130, 20);
        label_address.font = [UIFont systemFontOfSize:14];
        label_address.adjustsFontSizeToFitWidth = YES;
        label_address.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:label_address];
    }
    label_address.text = @"合肥市长江西路555号天际大厦201";
    //显示订单类别的
    if(label_type == nil){
        label_type = [[UILabel alloc]init];
        label_type.frame = FRAME(15, 10, WIDTH/2, 20);
        label_type.font = [UIFont systemFontOfSize:16];
        label_type.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        [self addSubview:label_type];
    }
    label_type.text = @"家具维修";
    //显示订单状态的
    if(label_state == nil){
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(WIDTH - 15 - 80, 10, 80, 20);
        label_state.textColor = [UIColor orangeColor];
        label_state.font = [UIFont systemFontOfSize:16];
        label_state.textAlignment = NSTextAlignmentRight;
        [self addSubview:label_state];
    }
    label_state.text = model.state;
    //显示支付或者评价按钮
    if(self.btn_pay == nil){
        self.btn_pay = [[UIButton alloc]init];
        self.btn_pay.frame = FRAME(WIDTH - 10 - 80, 147.5,80 , 30);
        self.btn_pay.layer.cornerRadius = 2;
        self.btn_pay.layer.masksToBounds = YES;
        self.btn_pay.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.btn_pay];
    }
    if ([model.state isEqualToString:@"待结算"]) {
        [self.btn_pay setTitle:@"待结算" forState:UIControlStateNormal];
    }else if([model.state isEqualToString:@"待评价"]){
        [self.btn_pay setTitle:@"去评价" forState:UIControlStateNormal];
    }
    else{
        [self.btn_pay setTitle:@"去支付" forState:UIControlStateNormal];
    }
    
    
    self.btn_pay.backgroundColor = [UIColor orangeColor];
    if ([model.state isEqualToString:@"待接单"]||[model.state isEqualToString:@"已评价"]||[model.state isEqualToString:@"已取消"]) {
        self.btn_pay.hidden = YES;
    }else{
        self.btn_pay.hidden = NO;
    }
    //显示取消订单还是删除订单
    if (self.btn_cancel == nil) {
        self.btn_cancel = [[UIButton alloc]init];
        self.btn_cancel.layer.cornerRadius = 2;
        self.btn_cancel.layer.masksToBounds = YES;
        self.btn_cancel.layer.borderColor = [UIColor orangeColor].CGColor;
        self.btn_cancel.layer.borderWidth = 1;
        self.btn_cancel.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.btn_cancel];
        
    }
    if ([model.state isEqualToString:@"待接单"]||[model.state isEqualToString:@"已评价"]||[model.state isEqualToString:@"已取消"]) {
        self.btn_cancel.frame = FRAME(WIDTH - 10 - 80, 147.5,80 , 30);
    }else{
        self.btn_cancel.frame = FRAME(WIDTH - 20 - 160, 147.5, 80, 30);
    }
    if([model.state isEqualToString:@"待评价"]||[model.state isEqualToString:@"已评价"]||[model.state isEqualToString:@"已取消"]){
        [self.btn_cancel setTitle:@"删除订单" forState:UIControlStateNormal];
    }else{
        [self.btn_cancel setTitle:@"取消订单" forState:UIControlStateNormal];
    }
    [self.btn_cancel setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    [self setModel:self.model];
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    [self setModel:self.model];
}

@end
