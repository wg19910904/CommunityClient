//
//  AddSeatNameCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "AddSeatNameCell.h"

@implementation AddSeatNameCell
{
    HZQButton * oldBtn;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    NSArray * array = @[NSLocalizedString(@"先生", nil),NSLocalizedString(@"女生", nil)];
    _textField_input = [[UITextField alloc]init];
    _textField_input.frame = FRAME(10, 5, 140, 30);
    _textField_input.placeholder = NSLocalizedString(@"尊称:请输入您的姓名", nil);
    _textField_input.font = FONT(14);
    [self addSubview:_textField_input];
    for (int i =0; i < 2; i ++) {
        HZQButton * btn = [[HZQButton alloc]initWithText:array[i] selecterImage:[UIImage imageNamed:@"icon-select-click"] defaultImage:[UIImage imageNamed:@"icon-select-default"]];
        btn.frame = FRAME(WIDTH - (55+[array[i] length]*14)*2+(55+[array[i] length]*14)*i, 5, 55+[array[i] length]*14, 30);
        btn.tag = i;
        if (i == 0) {
            btn.selected = YES;
            oldBtn = btn;
        }
        [btn addTarget:self action:@selector(clickSelecter:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

-(void)setModel:(JHAddSeatModel *)model{
    _model=model;
}
#pragma mark - 这是点击选择的方法
-(void)clickSelecter:(HZQButton *)sender{
    oldBtn.selected = NO;
    sender.selected = !sender.selected;
    oldBtn = sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(choseSex:)]) {
        [self.delegate choseSex:sender.tag];
    }
}
@end
