//
//  JHNewRechargeCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHNewRechargeCell.h"
#import "JHRechargeView.h"

@interface JHNewRechargeCell(){
    UILabel *titleL;
    
}


@end

@implementation JHNewRechargeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setUI{
    
  
}
-(void)setArr:(NSArray *)arr{
    _arr  = arr;
    titleL = [[UILabel alloc]init];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset =14;
        make.left.offset = 12;
        make.height.offset = 21;
        make.width.offset = WIDTH;
    }];
    
    titleL.textColor = TEXT_COLOR;
    titleL.font = FONT(15);
    titleL.text = @"选择充值金额";
    CGFloat W = 100 *PROPORTION;
    CGFloat H = 50 *PROPORTION;
    NSInteger rank = 3;
    CGFloat rankMargin = (WIDTH - rank * W) / (rank +1);
    CGFloat rowMargin = 15*PROPORTION;
    for (int i =0; i<_arr.count; i++) {
        CGFloat X = (i % rank) * (W + rankMargin) +rankMargin;
        NSUInteger Y = (i / rank) * (H +rowMargin);
        CGFloat top = 45;
        JHRechargeView *view = [[JHRechargeView alloc] initWithFrame:CGRectMake(X, Y+top, W, H)];
        view.dic = _arr[i];
        view.tag = i+100;
        [view addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];
//        view.frame = ;
        [self addSubview:view];
    }
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"changeView" object:nil userInfo:@{@"tag":@(100)}]];
    
    
    
}
-(void)viewClick:(JHRechargeView * )sender{
    NSInteger tag = sender.tag;

    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"changeView" object:nil userInfo:@{@"tag":@(tag)}]];
    
    if (_clickBlock) {
        self.clickBlock(tag);
    }
       
}


+(CGFloat)getHeight:(id)model{
    NSArray *arr = model;
    return (arr.count%3>0 ?arr.count/3 +1 :arr.count/3)* (50 +15) *PROPORTION + 45;
    
}

+(NSString *)getIdentifier{
    return @"JHNewRechargeCell";
}

@end
