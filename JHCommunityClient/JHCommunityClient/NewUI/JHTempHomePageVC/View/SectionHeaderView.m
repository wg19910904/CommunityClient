//
//  SectionHeaderView.m
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/24.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "SectionHeaderView.h"
@interface SectionHeaderView(){
    NSMutableArray *btnArr;
}
@property(nonatomic,strong)UIButton *oldBtn;//按钮
@property(nonatomic,strong)UIView *bottomLine;//底部的分割线线
@property(nonatomic,strong)UIView *moveLine;//移动的线
@end
@implementation SectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        btnArr = @[].mutableCopy;
        //点击的按钮
        [self creatBtn];
        //底部的分割线线
        [self bottomLine];
        //移动的线
        [self moveLine];
    }
    return self;
}
-(void)creatBtn{
    NSArray *titleArr = @[NSLocalizedString(@"推荐商家", nil),NSLocalizedString(@"社区头条", nil)];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.titleLabel.font = FONT(17);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"1d1c1c", 1) forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"fa6720", 1) forState:UIControlStateSelected];
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected =  YES;
            _oldBtn = btn;
        }
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = WIDTH/2*i;
            make.height.offset = 40;
            make.width.offset = WIDTH/2;
            make.top.offset = 2;
        }];
        [btnArr addObject:btn];
    }
}
-(void)setIsNew:(BOOL)isNew{
    _isNew = isNew;
    UIButton *btn;
    if (isNew) {
        btn = btnArr[1];
    }else{
        btn = btnArr[0];
    }
    [self clickBtn:btn];
}
-(void)clickBtn:(UIButton *)sender{
    _oldBtn.selected = NO;
    sender.selected = !sender.selected;
    _oldBtn = sender;
    [UIView animateWithDuration:0.25 animations:^{
        _moveLine.center = CGPointMake(WIDTH/4+WIDTH/2*sender.tag, _moveLine.centerY);
    }];
    if (self.myBlock) {
        self.myBlock(sender.tag);
    }
}
//添加底部的线
-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = HEX(@"dedede", 1);
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset = -0;
            make.left.offset = 0;
            make.right.offset = -0;
            make.height.offset = 0.5;
        }];
    }
    return _bottomLine;
}
//移动的线
-(UIView *)moveLine{
    if (!_moveLine) {
        _moveLine = [[UIView alloc]init];
        _moveLine.frame = FRAME((WIDTH/2-70)/2, 43, 70, 1);
        _moveLine.backgroundColor = HEX(@"fa6720", 1);
        [self addSubview:_moveLine];
    }
    return _moveLine;
}
@end
