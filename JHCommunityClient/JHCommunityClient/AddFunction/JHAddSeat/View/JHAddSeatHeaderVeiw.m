//
//  JHAddSeatHeaderVeiw.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHAddSeatHeaderVeiw.h"

@implementation JHAddSeatHeaderVeiw
{
    UIScrollView * _myScrollVeiw;//底部的滑动视图,防止后期时间段的增加
    CALayer * layer_line;//底部的线
    NSMutableArray * btn_array;//存放按钮的数组

}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubView];
    }
    return self;
}
-(void)creatSubView{
    btn_array = @[].mutableCopy;
    _myScrollVeiw = [[UIScrollView alloc]init];
    _myScrollVeiw.frame = FRAME(0, 0, WIDTH, 40);
    _myScrollVeiw.backgroundColor = [UIColor whiteColor];
    _myScrollVeiw.showsHorizontalScrollIndicator = NO;
    _myScrollVeiw.bounces = NO;
    [self addSubview:_myScrollVeiw];
    //创建底部的线
    layer_line = [[CALayer alloc]init];
    layer_line.backgroundColor = THEME_COLOR.CGColor;
    layer_line.frame = FRAME(0, 39, WIDTH/2, 1);
    [_myScrollVeiw.layer addSublayer:layer_line];
    
}
-(void)setModel:(JHAddSeatModel *)model{
    _model = model;
    _myScrollVeiw.contentSize = _myScrollVeiw.contentSize = CGSizeMake(WIDTH/2*model.num, 40);
    if (model.num > 2) {
        _myScrollVeiw.scrollEnabled = YES;
    }else{
        _myScrollVeiw.scrollEnabled = NO;
    }
    if (btn_array.count > 0) {
        for (UIButton * btn  in btn_array) {
            [btn removeFromSuperview];
        }
    }
    [btn_array removeAllObjects];
    for (int i = 0; i < model.num; i ++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = FRAME(WIDTH/2*i, 0, WIDTH/2, 39);
        [btn setTitle:model.timeArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(14);
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn_array addObject:btn];
        [_myScrollVeiw addSubview:btn];
    }
}
#pragma mark - 这是点击按钮调用的方法
-(void)clickBtn:(UIButton *)sender{
    layer_line.frame = FRAME(WIDTH/2*sender.tag, 39, WIDTH/2, 1);
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickTimeWithTag:)]) {
        [self.delegate clickTimeWithTag:sender.tag];
    }
}
@end
