//
//  FirstOrderFirstCell.m
//  Lunch
//
//  Created by jianghu1 on 15/12/16.
//  Copyright © 2015年 jianghu. All rights reserved.
//  高度为87

#import "FirstOrderFirstCell.h"

@implementation FirstOrderFirstCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加子视图
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    
    return self;
}

//添加子控件
- (void)createSubViews
{
    //添加左边图片
    UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 28.5, 25.5, 30)];
    leftIV.image = [UIImage imageNamed:@"order_postion"];
    
    //titileLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 3, WIDTH - 100, 40)];
    titleLabel.tag  = 1;
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    //addressLabel
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, WIDTH - 100, 40)];
    addressLabel.tag = 2;
    addressLabel.backgroundColor  = [UIColor whiteColor];
    addressLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    addressLabel.font = [UIFont systemFontOfSize:13];
    
    //右侧按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 38 , 28.5, 18, 30)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"arrowR"] forState:UIControlStateNormal];
    rightBtn.tag = 3;
    
    //添加上下边线
    UIImageView *topIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, WIDTH, 2)];
    topIV.image = [UIImage imageNamed:@"orderTopLine"];
    
    //添加下边线
    UIImageView *bottomIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 86, WIDTH, 2)];
    bottomIV.image = [UIImage imageNamed:@"orderTopLine"];
    
    //添加到子视图
    [self addSubview:leftIV];
    [self addSubview:titleLabel];
    [self addSubview:addressLabel];
    [self addSubview:rightBtn];
    [self addSubview:topIV];
    [self addSubview:bottomIV];
}
@end
