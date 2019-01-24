//
//  JHUPKeepOrderDetailCellTwo.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHUPKeepOrderDetailCellTwo.h"

@implementation JHUPKeepOrderDetailCellTwo
{
    UILabel * label;//添加分割线
    UILabel * label_state;//订单的状态
    UILabel * label_time;//显示时间的
    NSArray * array;
    NSArray * arrayImage;
    
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(takeawayDetailModel *)model{
    if (array == nil) {
        array = @[@"",@"",@"待评价",@"已结算",@"已接单(18756220578)",@"定金已支付",@"提交已订单"];
        arrayImage = @[@"",@"",@"payYes",@"payYes",@"commit",@"commit",@"commit"];
    }
    _model = model;
    //创建头像
    if (self.imageView_head == nil) {
        self.imageView_head = [[UIImageView alloc]init];
        self.imageView_head.frame = FRAME(25, 27.5, 25, 25);
        //self.imageView_head.backgroundColor = [UIColor greenColor];
        self.imageView_head.image = [UIImage imageNamed:arrayImage[self.indexPath.row]];
        [self addSubview:self.imageView_head];
    }
    //创建分割线
    if(label == nil){
        label = [[UILabel alloc]init];
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
    if (self.indexPath.row == 2) {
        self.label_praogressOne.hidden = YES;
    }else if (self.indexPath.row == 6){
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
    label_state.text = array[self.indexPath.row];
    //创建显示时间的label
    if (label_time == nil) {
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(80, 55, 150, 20);
        label_time.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:label_time];
        label_time.font = [UIFont systemFontOfSize:13];
    }
    
    if(self.indexPath.row == 2){
        label_time.text = @"评价师傅,可以获得积分哟";
    }else{
        label_time.text = @"2016-3-1 12:20:37";
    }
    if (self.indexPath.row == 4) {
        if (self.btn_call == nil) {
            self.btn_call = [[UIButton alloc]init];
            self.btn_call.frame = FRAME(WIDTH - 50, 20, 40, 40);
            [self addSubview:self.btn_call];
            [self.btn_call setImage:[UIImage imageNamed:@"phone01"] forState:UIControlStateNormal];
        }
    }
}

@end
