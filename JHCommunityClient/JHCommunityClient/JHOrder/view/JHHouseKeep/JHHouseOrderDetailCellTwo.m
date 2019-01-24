//
//  JHHouseOrderDetailCellTwo.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/16.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHouseOrderDetailCellTwo.h"

@implementation JHHouseOrderDetailCellTwo
{
    UIView * label;//添加分割线
    UILabel * label_state;//订单的状态
    UILabel * label_time;//显示时间的
    NSArray * array;
    NSArray * arrayImage;
    
}

-(void)setModel:(JHHouseProgressModel *)model{
    _model = model;
    //创建头像
    if (self.imageView_head == nil) {
        self.imageView_head = [[UIImageView alloc]init];
        self.imageView_head.frame = FRAME(25, 27.5, 25, 25);
        [self addSubview:self.imageView_head];
    }
    JHHModel * otherModel = model.modelArray[self.indexPath.row - 2];
    if ([otherModel.from isEqualToString:@"shop"]) {
        self.imageView_head.image = [UIImage imageNamed:@"shop_order"];
    }else if ([otherModel.from isEqualToString:@"staff"]){
        self.imageView_head.image = [UIImage imageNamed:@"goToSend"];
    }else if ([otherModel.from isEqualToString:@"payment"]){
        self.imageView_head.image = [UIImage imageNamed:@"pay"];
    }
    else{
        self.imageView_head.image = [UIImage imageNamed:@"submitOrder"];
    }
    //创建分割线
    if(label == nil){
        label = [[UIView alloc]init];
        label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        label.frame = FRAME(80, 79.5, WIDTH - 80, 0.5);
        [self addSubview:label];
    }
    //创建进度的连线
    if(self.label_praogressOne == nil){
        self.label_praogressOne = [[UILabel alloc]init];
        self.label_praogressOne.frame = FRAME(36.5, 0, 1, 27.5);
        [self addSubview:self.label_praogressOne];
        self.label_praogressOne.backgroundColor = THEME_COLOR;
    }
    if (self.label_praogressTwo == nil) {
        self.label_praogressTwo = [[UILabel alloc]init];
        self.label_praogressTwo.frame = FRAME(36.5, 52.5, 1, 27.5);
        [self addSubview:self.label_praogressTwo];
        self.label_praogressTwo.backgroundColor = THEME_COLOR;
    }
    self.label_praogressOne.hidden = NO;
    self.label_praogressTwo.hidden = NO;
    if (self.indexPath.row == 2 && model.modelArray.count == 1) {
        self.label_praogressOne.hidden = YES;
        self.label_praogressTwo.hidden = YES;
    }else if (self.indexPath.row == 2&&model.modelArray.count > 1) {
        self.label_praogressOne.hidden = YES;
    }else if (self.indexPath.row == model.modelArray.count + 1&&model.modelArray.count > 1){
        self.label_praogressTwo.hidden = YES;
    }
    //创建显示订单状态的label
    if (label_state == nil) {
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(80, 15, WIDTH - 160, 30);
        label_state.textColor= [UIColor colorWithWhite:0.3 alpha:1];
        [self addSubview:label_state];
        label_state.numberOfLines = 2;
        label_state.adjustsFontSizeToFitWidth = YES;
        label_state.font = [UIFont systemFontOfSize:14];
    }
    label_state.text = otherModel.text;
    //创建显示时间的label
    if (label_time == nil) {
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(80, 55, 150, 20);
        label_time.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:label_time];
        label_time.font = [UIFont systemFontOfSize:13];
    }
    label_time.text = otherModel.dateline;
        if (self.btn_call == nil) {
            self.btn_call = [[UIButton alloc]init];
            self.btn_call.frame = FRAME(WIDTH - 50, 20, 40, 40);
            [self addSubview:self.btn_call];
            [self.btn_call setImage:[UIImage imageNamed:@"phone01"] forState:UIControlStateNormal];
        }
    self.btn_call.hidden = YES;
}
@end
