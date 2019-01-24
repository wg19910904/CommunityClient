//
//  ChoseTimeCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "ChoseTimeCell.h"

@implementation ChoseTimeCell
{
    UIScrollView * _myScrollVeiw;//底部的滑动视图,防止后期时间段的增加
    NSMutableArray * btn_array;//存放按钮的数组
    UIButton * oldBtn;
    NSString * selecter;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        btn_array = @[].mutableCopy;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = BACK_COLOR;
        [self creatSubView];
    }
    return self;
}
-(void)creatSubView{
    _myScrollVeiw = [[UIScrollView alloc]init];
    _myScrollVeiw.backgroundColor = BACK_COLOR;
    _myScrollVeiw.showsHorizontalScrollIndicator = NO;
    _myScrollVeiw.bounces = NO;
    [self addSubview:_myScrollVeiw];
}
-(void)setModel:(JHAddSeatModel *)model{
    _model = model;
    if (model.infoArray.count <=4) {
        _myScrollVeiw.frame = FRAME(0, 0, WIDTH, 70);
    }else{
        _myScrollVeiw.frame = FRAME(0, 0, WIDTH, 120);
    }
    if (model.infoArray.count>8) {
        _myScrollVeiw.scrollEnabled = YES;
        _myScrollVeiw.contentSize = _myScrollVeiw.contentSize = CGSizeMake(WIDTH*2, 40);
    }else{
        _myScrollVeiw.scrollEnabled = NO;
        _myScrollVeiw.contentSize = _myScrollVeiw.contentSize = CGSizeMake(WIDTH, 40);
    }
    if (btn_array.count > 0) {
        for (UIButton * btn  in btn_array) {
            [btn removeFromSuperview];
        }
    }
    [btn_array removeAllObjects];
    for (int i = 0; i < model.infoArray.count; i ++) {
        UIButton * btn = [[UIButton alloc]init];
        if (i < 8) {
            btn.frame = FRAME(10 + ((WIDTH - 35)/4 + 5)*(i%4),10 + (50 + 5)*(i/4), (WIDTH - 35)/4, 50);
        }else{
             btn.frame = FRAME(WIDTH + 10 + ((WIDTH - 35)/4 + 5)*((i - 8)%4),10 + (50 + 5)*((i-8)/4), (WIDTH - 35)/4, 50);
        }
        if (i == selecter.integerValue && selecter) {
            btn.selected = YES;
            oldBtn = btn;
        }
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        [btn setTitle:model.infoArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:THEME_COLOR forState:UIControlStateSelected];
        btn.titleLabel.font = FONT(14);
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn_array addObject:btn];
        [_myScrollVeiw addSubview:btn];
    }
}
#pragma mark - 这是点击时间的按钮
-(void)clickBtn:(UIButton *)sender{
    oldBtn.selected = NO;
    sender.selected = !sender.selected;
    oldBtn = sender;
    selecter = @(sender.tag).stringValue;
    if (self.myBlock) {
        self.myBlock(sender.tag);
    }
}
@end
