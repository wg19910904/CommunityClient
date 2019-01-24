//
//  CommunityHeaderView.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "CommunityHeaderView.h"
#import "KindBtn.h"
#import <UIImageView+WebCache.h>

#define btnTag  200
CGFloat screenWidth = 375;
@interface CommunityHeaderView()<CAAnimationDelegate>
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,weak)UILabel *typeTitle;
@property(nonatomic,strong)UIButton *scrollBtn;//滚动的通知
@property(nonatomic,assign)int titleIndex;
@property(nonatomic,strong)NSArray *scrArr;
@property(nonatomic,assign)NSTimeInterval timeInterval;
@end

@implementation CommunityHeaderView

-(CommunityHeaderView *)initViewWith:(NSArray *)adImages kinds:(NSArray *)kinds scrArr:(NSArray *)scrArr bottomAds:(NSArray *)botArr  time:(NSTimeInterval)time scrollH:(CGFloat)scrollH{
    
    
    self.titleIndex=0;
    self.timeInterval=time;
    self.backgroundColor=[UIColor whiteColor];
    
    CGFloat button_Width = (screenWidth - 5 * 10)/4;
    CGFloat button_Height =button_Width;
    CGFloat space = (WIDTH - button_Width * 4) / 5;
    if (scrollH!=0) {
        NSMutableArray *arr=[NSMutableArray array];
        for (NSDictionary *dic in adImages) {
            NSString *url=[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"photo"]];
            [arr addObject:url];
        }
        MJBannnerPlayer *adView=[[MJBannnerPlayer alloc] initWithUrlArray:arr withSize:CGRectMake(0, 0, WIDTH, scrollH) withTimeInterval:2.0];
        adView.placeHolderImage=@"bannerDefault";
        [self addSubview:adView];
        self.adView=adView;
        adView.clickAD=^(NSInteger index){
            if (self.clickADs)   self.clickADs(index,NO);
        };
    }
    
    CGFloat margin=scrollH;
    if (scrArr.count!=0) {
        NSMutableArray *arr=[NSMutableArray array];
        for (NSDictionary *dic in adImages) {
            [arr addObject:dic[@"title"]];
        }
        self.scrArr=arr;
        
        UIView *view=[UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.top.offset=scrollH;
            make.width.offset=WIDTH;
            make.height.offset=40;
        }];
        view.backgroundColor=HEX(@"ffffff", 1.0);
        
        UILabel *typeLab=[UILabel new];
        [view addSubview:typeLab];
        [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.top.offset=10;
            make.width.offset=30;
            make.height.offset=20;
        }];
        typeLab.text=@"通知";
        typeLab.font=FONT(12);
        typeLab.textAlignment=NSTextAlignmentCenter;
        typeLab.backgroundColor=HEX(@"59C181", 1.0);
        typeLab.layer.cornerRadius=2;
        typeLab.clipsToBounds=YES;
        typeLab.textColor=[UIColor whiteColor];
        self.typeTitle=typeLab;
        
        UIButton *scrollBtn=[UIButton new];
        [view addSubview:scrollBtn];
        [scrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(typeLab.mas_right).offset=10;
            make.top.offset=10;
            make.width.offset=WIDTH-50;
            make.height.offset=20;
        }];
        scrollBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        scrollBtn.titleLabel.font=FONT(14);
        [scrollBtn setTitleColor:HEX(@"686868", 1.0) forState:UIControlStateNormal];
        [scrollBtn addTarget:self action:@selector(onCLickTitle) forControlEvents:UIControlEventTouchUpInside];
        [scrollBtn setTitle:scrArr[0] forState:UIControlStateNormal];
        self.scrollBtn=scrollBtn;
        self.titleIndex=0;
        margin=scrollH+40;
        [self timer];
    }
    
   
    
    UIView *btnBgView=[[UIView alloc] initWithFrame:CGRectMake(0, margin, WIDTH, 0)];
    [self addSubview:btnBgView];
    btnBgView.backgroundColor=[UIColor whiteColor];
    
    int max=1;
    if (kinds.count>4) max=2;
    btnBgView.height=button_Height*max+25;
    
    UIView *lineView=[UIView new];
    [self addSubview:lineView];
    lineView.backgroundColor=LINE_COLOR;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset=margin;
        make.left.offset=0;
        make.width.offset=WIDTH;
        make.height.offset=0.5;
    }];
    
    for (int i=0; i<kinds.count; i++) {
        int x = i%4;
        int y = i/4;
        KindBtn *kindBtn=[[KindBtn alloc]initWithFrame:CGRectMake(space + (button_Width + space)*x, 10+margin+(button_Height + 10) * y, button_Width, button_Height)];
        [self addSubview:kindBtn];
        kindBtn.tag=btnTag+i;
        
        NSDictionary *dic=kinds[i];
//        NSString *str=[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"icon"]];
        kindBtn.title=dic[@"title"];
//        [kindBtn.iconView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:IMAGE(@"house&maintain&paotuiorderevaluationphoto")];
        kindBtn.iconView.image=IMAGE(dic[@"icon"]) ;
    
        [kindBtn addTarget:self action:@selector(clickKindView:) forControlEvents:UIControlEventTouchUpInside];
       
        if (i==kinds.count-1) {
            UIView *lineView=[UIView new];
            [self addSubview:lineView];
            lineView.backgroundColor=LINE_COLOR;
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset=margin+10+button_Height*max+14;
                make.left.offset=0;
                make.width.offset=WIDTH;
                make.height.offset=1;
            }];
        }
    }

    UIView *view2=[UIView new];
    view2.backgroundColor=BACK_COLOR;
    [self addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=margin+10+button_Height*max+15;
        make.width.offset=WIDTH;
        make.height.offset=10;
    }];
 
    UIView *bottomAdView=[UIView new];
    [self addSubview:bottomAdView];
    [bottomAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom).offset=0;
        make.left.offset=0;
        make.width.offset=WIDTH;
        make.height.offset=60;
    }];
    
    for (int i=0; i<botArr.count; i++) {
        CGRect frame=CGRectMake(WIDTH/2.0*i, 0, WIDTH/2.0, 60);
        BOOL is_left=NO;
        if (i==0) is_left=YES;
        
        UIView *view= [self createViewWith:botArr[i] frame:frame isLeft:is_left];
        [bottomAdView addSubview:view];
        if (i==0) {
            UIView *lineView=[UIView new];
            [bottomAdView addSubview:lineView];
            lineView.backgroundColor=LINE_COLOR;
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset=0;
                make.left.offset=WIDTH/2.0-0.5;
                make.width.offset=1;
                make.height.offset=60;
            }];
        }
    }
    
    UIView *botLine1=[UIView new];
    [bottomAdView addSubview:botLine1];
    botLine1.backgroundColor=LINE_COLOR;
    [botLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset=0;
        make.left.offset=0;
        make.width.offset=WIDTH;
        make.height.offset=0.5;
    }];
    
    UIView *botLine2=[UIView new];
    [bottomAdView addSubview:botLine2];
    botLine2.backgroundColor=LINE_COLOR;
    [botLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomAdView.mas_bottom).offset=-1;
        make.left.offset=0;
        make.width.offset=WIDTH;
        make.height.offset=1;
    }];
    
    float height=btnBgView.height+10+60+margin;
    self.frame=CGRectMake(0,0, WIDTH,height);
    return self;
}

-(UIView *)createViewWith:(NSDictionary *)dic frame:(CGRect)frame isLeft:(BOOL)isLeft{
//    UIView *view=[[UIView alloc] initWithFrame:frame];
//    view.backgroundColor=[UIColor whiteColor];
//    
//    UILabel *lab=[UILabel new];
//    [view addSubview:lab];
//    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset=10;
//        make.top.offset=10;
//        make.width.offset=view.width-60;
//        make.height.offset=20;
//    }];
//    lab.font=FONT(15);
//    lab.textColor=HEX(@"333333", 1.0);
//    lab.text=dic[@"title"];
//    
//    UILabel *typeLab=[UILabel new];
//    [view addSubview:typeLab];
//    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset=10;
//        make.top.equalTo(lab.mas_bottom).offset=5;
//        make.width.offset=40;
//        make.height.offset=15;
//    }];
//    typeLab.font=FONT(12);
//    typeLab.textAlignment=NSTextAlignmentCenter;
//    typeLab.text= isLeft ? @"NEW":@"HOT";
//    typeLab.textColor=HEX(@"ff3300", 1.0);
//    typeLab.layer.borderColor=HEX(@"ff3300", 1.0).CGColor;
//    typeLab.layer.borderWidth=1.0;
//    typeLab.layer.cornerRadius=7.5;
//    typeLab.clipsToBounds=YES;
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:frame];;
    NSString *url=[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"photo"]];
    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:DefaultImgViewImage];
    
    imgView.tag=isLeft ? 400:401;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBottomAD:)];
    [imgView addGestureRecognizer:tap];
    imgView.userInteractionEnabled=YES;
    return imgView;
}



#pragma mark ======滚动通知=======
-(void)startScrollAnimation{
    self.titleIndex++;
    if (self.titleIndex==self.scrArr.count)    self.titleIndex=0;
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    [animation setDuration:1.0f];
    [animation setType:@"cube"];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setFillMode:kCAFillModeRemoved];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [self.scrollBtn.layer addAnimation:animation forKey:nil];

    [self.scrollBtn setTitle:self.scrArr[self.titleIndex] forState:UIControlStateNormal];
}

-(NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(startScrollAnimation) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

#pragma mark ======点击事件=======
-(void)clickKindView:(UIButton *)btn{
    NSInteger index=btn.tag - btnTag;
    if (self.clickKind)  self.clickKind(index);
}

-(void)onCLickTitle{
    if (self.clickMsg)  self.clickMsg(self.titleIndex);
}

-(void)clickBottomAD:(UITapGestureRecognizer *)tap{
    NSInteger index=tap.view.tag-400;
    if (self.clickADs)  self.clickADs(index,YES);
}

#pragma mark ======setter 和  getter=======

-(void)setTypeStr:(NSString *)typeStr{
    _typeStr=typeStr;
    self.typeTitle.text=typeStr;
}

-(void)setTypeColor:(NSString *)typeColor{
    self.typeTitle.backgroundColor=HEX(typeColor, 1.0);
}

-(void)dealloc{
    [self.timer invalidate];
    _timer=nil;
}

@end
