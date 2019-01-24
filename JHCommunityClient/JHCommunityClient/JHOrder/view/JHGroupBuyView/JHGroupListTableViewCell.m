//
//  JHGroupListTableViewCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/4/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHGroupListTableViewCell.h"
#import "UIImageView+NetStatus.h"
@implementation JHGroupListTableViewCell
{
    UIView * view_LineOne;//头部的分割线
    UIImageView * imageView_type;//创建显示订单类型的
    UILabel * label_name;//菜名
    UILabel * label_state;//显示订单的状态
    UIImageView * imageView;//显示大图片
    UILabel * label_count;//显示点的份数
    UILabel * label_totalMoney;//显示总的钱数的label
    UILabel * label_time;//显示下单时间的
    UIView * view;
}

-(void)setModel:(JHGroupModel*)model{
    _model = model;
    //创建头部的分割线
    if(view_LineOne == nil){
        view_LineOne = [[UIView alloc]init];
        view_LineOne.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        view_LineOne.frame = FRAME(0, 0, WIDTH, 0.5);
        [self addSubview:view_LineOne];
        //创建第二根分割线
        UIView * view_LineTwo = [[UIView alloc]init];
        view_LineTwo.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        view_LineTwo.frame = FRAME(0, 40, WIDTH, 0.5);
        [self addSubview:view_LineTwo];
        //创建第三根分割线
        UIView * view_LineThree = [[UIView alloc]init];
        view_LineThree.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        view_LineThree.frame = FRAME(0, 120, WIDTH, 0.5);
        [self addSubview:view_LineThree];
        //创建第四根分割线
        UIView * view_LineFour = [[UIView alloc]init];
        view_LineFour.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        view_LineFour.frame = FRAME(0, 160, WIDTH, 0.5);
        [self addSubview:view_LineFour];
        //创建单元格之间的空隙
        view = [[UIView alloc]init];
        view.frame = FRAME(0, 160.5, WIDTH, 14.5);
        [self addSubview:view];
    }
    view.backgroundColor = [UIColor colorWithWhite:0.99 alpha:1];
    //创建订单订单的类型图标(外卖)
    if(imageView_type == nil){
        imageView_type = [[UIImageView alloc]init];
        imageView_type.frame = FRAME(15, 10, 20, 20);
        [self addSubview:imageView_type];
    }
    imageView_type.image = [UIImage imageNamed:model.type];
    //创建显示订单名的label
    if(label_name == nil){
        label_name = [[UILabel alloc]init];
        label_name.frame = FRAME(40, 10, WIDTH - 130, 20);
        label_name.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        //label_name.textAlignment = NSTextAlignmentCenter;
        label_name.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_name];
    }
    label_name.text = model.tuan_title;
    //创建显示订单的状态的(待支付/已支付)
    if(label_state == nil){
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(WIDTH - 80, 10, 70, 20);
        label_state.textAlignment = NSTextAlignmentRight;
        label_state.textColor = THEME_COLOR;
        [self addSubview:label_state];
    }
    label_state.text = model.order_status_label;
    
    //创建显示订单的图片
    if(imageView == nil){
        imageView = [[UIImageView alloc]init];
        imageView.frame = FRAME(15, 50, 60, 60);
        [self addSubview:imageView];
    }
   // NSString * url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.photoOther];
    NSString * url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.photo];
    [imageView sd_image:[NSURL URLWithString:url] plimage:[UIImage imageNamed:@"supermarketproduct"]];
    //创建显示份数的label
    if (label_count == nil) {
        label_count= [[UILabel alloc]init];
        label_count.frame = FRAME(80, 55, 100, 20);
        label_count.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        label_count.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_count];
    }
    label_count.text = [NSString stringWithFormat:NSLocalizedString(@"%@份", nil),model.tuan_number];
    //创建显示总的钱数的label
    if(label_totalMoney == nil){
        label_totalMoney = [[UILabel alloc]init];
        label_totalMoney.frame = FRAME(80, 80, 200, 20);
        label_totalMoney.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        label_totalMoney.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_totalMoney];
    }
    label_totalMoney.text = [NSString stringWithFormat:NSLocalizedString(@"¥ %@", nil),model.tuan_price];
    //创建显示下单时间的label
    if(label_time == nil){
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(15, 120, WIDTH/2+20, 40);
        label_time.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        [self addSubview:label_time];
        label_time.numberOfLines = 0;
        label_time.font = [UIFont systemFontOfSize:11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ];
    }
    NSString  * time = [self getTimeWithDataLine:model.dateline];
    label_time.text = [NSString stringWithFormat:NSLocalizedString(@"订单号:%@\n下单时间:%@", nil),model.order_id,time];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:label_time.text];
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
    [paragraph setLineSpacing:3];
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, label_time.text.length)];
    label_time.attributedText = attribute;
                                           
    //创建显示去支付还是去评价还是已评价的按钮
    if (self.btn == nil) {
        self.btn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = FRAME(WIDTH - 80, 125, 70, 30);
        [self addSubview:self.btn];
        self.btn.layer.cornerRadius = 2;
        self.btn.layer.masksToBounds = YES;
        self.btn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    if([model.order_status intValue] == 0 && [model.pay_status intValue] == 0){
        [self.btn setTitle:NSLocalizedString(@"去支付", nil) forState:UIControlStateNormal];
        self.btn.backgroundColor = THEME_COLOR;
        
    }else if ([model.order_status intValue] == 0){
        [self.btn setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        self.btn.backgroundColor = THEME_COLOR;
        
    }else if ([model.order_status intValue] == 8 && [model.comment_status intValue] == 0){
        [self.btn setTitle:NSLocalizedString(@"去评价", nil) forState:UIControlStateNormal];
        self.btn.backgroundColor = THEME_COLOR;
    }else if([model.order_status intValue] == 8 && [model.comment_status intValue] == 1){
        [self.btn setTitle:NSLocalizedString(@"已评价", nil) forState:UIControlStateNormal];
        self.btn.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        ;
    }else if ([model.order_status intValue] == -1){
        [self.btn setTitle:NSLocalizedString(@"已取消", nil) forState:UIControlStateNormal];
        self.btn.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        ;
    }
    else if([model.order_status intValue] == 5){
        [self.btn setTitle:NSLocalizedString(@"申请退款", nil) forState:UIControlStateNormal];
       self.btn.backgroundColor = THEME_COLOR;
    }else{
        self.btn.backgroundColor = [UIColor clearColor];
        [self.btn setTitle:@"" forState:UIControlStateNormal];
    }
    //创建在待支付的情况下的取消订单的按钮
    if(self.cancelBtn == nil){
        self.cancelBtn = [[UIButton alloc]init];
        self.cancelBtn.frame = CGRectMake(WIDTH - 157, 125, 70, 30);
        self.cancelBtn.layer.cornerRadius = 2;
        self.cancelBtn.clipsToBounds = YES;
        self.cancelBtn.layer.borderColor = THEME_COLOR.CGColor;
        self.cancelBtn.layer.borderWidth = 1;
        [self.cancelBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [self.cancelBtn setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.cancelBtn];
    }
    if([model.order_status intValue] == 0 && [model.pay_status intValue] == 0){
        self.cancelBtn.hidden = NO;
    }else{
        self.cancelBtn.hidden = YES;
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
#pragma mark - 这是时间戳的转化方法
-(NSString *)getTimeWithDataLine:(NSString *)dateLine{
    NSInteger num = [dateLine integerValue];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
    NSString * time = [dateFormatter stringFromDate:date];
    return time;
}

@end
