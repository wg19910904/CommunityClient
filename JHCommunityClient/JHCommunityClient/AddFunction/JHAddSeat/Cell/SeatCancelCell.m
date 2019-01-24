//
//  SeatCancelCell.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SeatCancelCell.h"

@interface SeatCancelCell ()
@property(nonatomic,weak)UIButton *tittlBtn;
@end

@implementation SeatCancelCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIButton *btn=[UIButton new];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.bottom.offset=0;
    }];
    btn.titleLabel.font=FONT(14);
    btn.layer.cornerRadius=18;
    btn.clipsToBounds=YES;
    btn.layer.borderWidth=1.0;
    btn.layer.borderColor=HEX(@"f5f5f5", 1.0).CGColor;
    [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
    [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
    btn.userInteractionEnabled=NO;
    self.tittlBtn=btn;
}

-(void)setTitleStr:(NSString *)titleStr{
    [self.tittlBtn setTitle:titleStr forState:UIControlStateNormal];
}

-(void)setSelected:(BOOL)selected{
    
    self.tittlBtn.selected=selected;
    if (selected)  self.tittlBtn.layer.borderColor=THEME_COLOR.CGColor;
    else self.tittlBtn.layer.borderColor=HEX(@"f5f5f5", 1.0).CGColor;
    
}


@end
