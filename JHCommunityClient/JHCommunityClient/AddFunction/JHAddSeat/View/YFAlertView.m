//
//  YFAlertView.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "YFAlertView.h"
#import "AppDelegate.h"

@interface YFAlertView()
@property(nonatomic,weak)UIView *centerView;
@property(nonatomic,weak)UIControl *control;
@property(nonatomic,weak)UILabel *desLab;

@end

@implementation YFAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIControl *control = [[UIControl alloc]init];
    control.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    control.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    [control addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    control.alpha=0;
    self.control=control;
    
    UIView *centerView=[UIView new];
    [self.control addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.centerY.offset=0;
        make.width.offset=self.width;
//        make.height.offset=self.height;
    }];
    centerView.backgroundColor=[UIColor whiteColor];
    centerView.layer.cornerRadius=4;
    centerView.clipsToBounds=YES;
    centerView.alpha=0;
    self.centerView=centerView;
    
    UILabel *desLab=[UILabel new];
    [centerView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=15;
        make.right.offset=-10;
    }];
    desLab.font=FONT(14);
    desLab.textColor=HEX(@"333333", 1.0);
    desLab.numberOfLines=0;
    desLab.lineBreakMode=NSLineBreakByCharWrapping;
    self.desLab=desLab;
    
    UIView *lineView=[UIView new];
    [centerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(desLab.mas_bottom).offset=15;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    for (NSInteger i=0; i<2; i++) {
        
        UIButton *btn=[UIButton new];
        [centerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=self.width/2.0*i;
            make.top.equalTo(lineView.mas_bottom).offset=0;
            make.width.offset=self.width/2.0;
            make.height.offset=40;
        }];
        btn.titleLabel.font=FONT(14);
        if (i==0) {
            [btn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
            [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        }else{
            [btn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
            [btn setTitleColor:HEX(@"ff3300", 1.0) forState:UIControlStateNormal];
        }
        btn.tag=100+i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    UIView *vLineView=[UIView new];
    [centerView addSubview:vLineView];
    [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=self.width/2.0-0.25;
        make.top.equalTo(desLab.mas_bottom).offset=15;
        make.width.offset=0.5;
        make.bottom.offset=0;
    }];
    vLineView.backgroundColor=LINE_COLOR;
    
    [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView.mas_bottom).offset=40;
    }];
}

//点击确定或取消
-(void)click:(UIButton *)btn{
    if (btn.tag-100==1) {//确定
        if (self.clickSure)  self.clickSure();
    }
    [self hidden];
}

//消失
-(void)hidden{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.control.alpha=0;
        self.centerView.alpha=0;
    }];
    [self removeFromSuperview];
}

-(void)show{
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self.control];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.control.alpha=1;
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.centerView.alpha=1;
    }];
    
}

-(void)setDesStr:(NSString *)desStr{
    self.desLab.text=desStr;
}

@end
