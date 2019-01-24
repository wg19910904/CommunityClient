//
//  JHGroupTableViewCellOne.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHGroupTableViewCellOne.h"

@implementation JHGroupTableViewCellOne
{
    UIImageView * imageV;//创建头部的照片
    UIView * label_line;//创建分割线
    UILabel * label_name;//显示菜的名字
    UILabel * label_count;//显示份数的
    UILabel * label_money;//显示总的价格的
}

-(void)setModel:(JHGroupDetailModel *)model{
    _model = model;
    if(imageV == nil){
        imageV = [[UIImageView alloc]init];
        imageV.frame = FRAME(15, 15, 50, 50);
        [self addSubview:imageV];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.tuan_photo];
    [imageV sd_image:[NSURL URLWithString:url] plimage:[UIImage imageNamed:@"supermarketproduct"]];
    //添加分割线
    if (label_line == nil) {
        label_line = [[UIView alloc]init];
        label_line.frame =FRAME(0, 79.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    //添加显示菜的名字的
    if(label_name == nil){
        label_name = [[UILabel alloc]init];
        label_name.frame = FRAME(70, 15, WIDTH - 90, 20);
        label_name.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label_name.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_name];
    }
        label_name.text = model.tuan_title;
    //创建显示份数的
    if (label_count == nil) {
        label_count = [[UILabel alloc]init];
        label_count.frame = FRAME(70, 35, WIDTH/2, 20);
        label_count.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_count.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_count];
    }
    label_count.text = [NSString stringWithFormat:NSLocalizedString(@"%@份", nil),model.tuan_number];
    if(label_money == nil){
        label_money = [[UILabel alloc]init];
        label_money.frame = FRAME(70, 55, WIDTH, 20);
        label_money.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_money.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_money];
    }
    label_money.text = [NSString stringWithFormat:NSLocalizedString(@"¥ %@", nil),model.tuan_price];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
@end
