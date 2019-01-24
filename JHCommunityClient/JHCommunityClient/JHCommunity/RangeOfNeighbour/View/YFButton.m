//
//  YFButton.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "YFButton.h"

@interface YFButton ()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIImageView *imgView;
@end

@implementation YFButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIImageView *imgView=[UIImageView new];
    [self addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.centerY.offset=0;
        make.width.offset=20;
        make.height.offset=20;
    }];
    imgView.contentMode=UIViewContentModeCenter;
    self.imgView=imgView;
    
    UILabel *titleLab=[UILabel new];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset=5;
        make.centerY.offset=0;
        make.right.offset=0;
        make.height.offset=20;
    }];
    self.titleLab=titleLab;
}

-(void)setImgName:(NSString *)imgName{
    _imgName=imgName;
    self.imgView.image=IMAGE(imgName);
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr=titleStr;
    self.titleLab.text=titleStr;
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont=titleFont;
    self.titleLab.font=titleFont;
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor=titleColor;
    self.titleLab.textColor=titleColor;
}

-(void)setAdjustImgMargin:(float)adjustImgMargin{
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=adjustImgMargin;
        make.top.offset=adjustImgMargin;
    }];
}

@end
