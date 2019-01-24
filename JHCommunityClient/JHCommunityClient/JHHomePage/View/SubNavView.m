//
//  mainTableSecondHeadeView.m
//  Lunch
//
//  Created by jianghu on 15/11/25.
//  Copyright © 2015年 jianghu. All rights reserved.
//

#import "SubNavView.h"
@implementation SubNavView
{
    CGFloat width;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        width = WIDTH / 3 ;
        //添加分割竖线
        [self addVerLines];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = LINE_COLOR.CGColor;
    }
    return self;
}
#pragma mark - addVerLines
- (void)addVerLines
{
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake( width * (i + 1), 5, 1, self.frame.size.height - 10 )];
        lineView.backgroundColor = LINE_COLOR;
        [self addSubview:lineView];
    }
}
#pragma mark - 外部数据传入时,调用
- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    //添加按钮
    [self addButton];
}
#pragma mark - addButton
- (void)addButton
{
    //初始化并创建button数组
    _btn0 = [[UIButton alloc] init];
    _btn1 = [[UIButton alloc] init];
    _btn2 = [[UIButton alloc] init];
    NSArray *buttonArray = @[_btn0,_btn1,_btn2];
    for (int i = 0; i< 3; i++) {
        UIButton *temBtn = buttonArray[i];
        temBtn.frame = CGRectMake( width * i , 0 , width, self.frame.size.height);
        temBtn.tintColor = THEME_COLOR;
        //设置buton内图片属性和label属性的位置
        temBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, width / 5);
        temBtn.imageEdgeInsets = UIEdgeInsetsMake(5, width / 5 * 4, 5,0);
        //设置正常状态下 button的字体颜色 大小 及图片等
        [temBtn setTitle:_titleArray[i] forState:UIControlStateNormal];
        temBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [temBtn setTitleColor:HEX(@"333333",1.0f) forState:UIControlStateNormal];
        temBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [temBtn setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
        //设置选中状态下 button的字体颜色 大小及图片等
        [temBtn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [temBtn setImage:[UIImage imageNamed:@"arrowUp"] forState:UIControlStateSelected];
        temBtn.tag = i + 1;
        [self addSubview:temBtn];
    }
}
@end
