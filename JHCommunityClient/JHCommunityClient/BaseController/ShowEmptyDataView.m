//
//  ShowEmptyDataView.m
//  JHLive
//
//  Created by jianghu3 on 16/8/31.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "ShowEmptyDataView.h"

@interface ShowEmptyDataView ()
//@property(nonatomic,weak)ShowEmptyDataView *empty;
@property(nonatomic,weak)UIImageView *imageView;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,weak)UIButton *statusBtn;
@end

@implementation ShowEmptyDataView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=BACK_COLOR;
        [self createUISubview];
    }
    return self;
    
}

-(void)createUISubview{

    UIImageView * imageView = [UIImageView new];
    [self addSubview:imageView];
    self.imageView=imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.centerY.offset=-40;
//        make.width.offset=138;
//        make.height.offset=128;
    }];
    imageView.image = [UIImage imageNamed:@"pic_no"];
    
    
    UILabel *desLab=[UILabel new];
    [self addSubview:desLab];
     desLab.frame = FRAME(0, 300, WIDTH, 20);
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.top.equalTo(imageView.mas_bottom).offset=20;
        make.width.equalTo(self.mas_width);
    }];
    desLab.font = FONT(16);
    desLab.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    desLab.textAlignment = NSTextAlignmentCenter;
    self.desLab=desLab;
 
    UIButton *btn=[UIButton new];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.top.equalTo(desLab.mas_bottom).offset=20;
        make.width.offset=80;
        make.height.offset=40;
    }];
    btn.layer.cornerRadius=4;
    btn.clipsToBounds=YES;
    btn.layer.borderColor=THEME_COLOR.CGColor;
    btn.layer.borderWidth=1.0;
    [btn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    self.statusBtn=btn;
    btn.hidden=YES;
    
}

-(void)clickBtn{
    if (self.clickStatusBtn)  self.clickStatusBtn();
}

-(void)setIs_showBtn:(BOOL)is_showBtn{
    _is_showBtn=is_showBtn;
    self.statusBtn.hidden=!is_showBtn;
}

-(void)setStatusBtnTitle:(NSString *)statusBtnTitle{
    _statusBtnTitle=statusBtnTitle;
    [self.statusBtn setTitle:statusBtnTitle forState:UIControlStateNormal];
}

-(void)setBtnColor:(UIColor *)btnColor{
    _btnColor=btnColor;
    [self.statusBtn setTitleColor:btnColor forState:UIControlStateNormal];
}

-(void)setEmptyImg:(NSString *)emptyImg{
    _emptyImg = emptyImg;
    self.imageView.image = [UIImage imageNamed:emptyImg];
}

-(void)setDesStr:(NSString *)desStr{
    _desStr = desStr;
    self.desLab.text = desStr;
}

@end
