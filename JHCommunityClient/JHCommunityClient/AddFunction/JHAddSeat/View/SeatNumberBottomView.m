//
//  SeatNumberBottomView.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SeatNumberBottomView.h"

@interface SeatNumberBottomView ()
@property(nonatomic,weak)UIButton *firstBtn;
@property(nonatomic,weak)UIButton *secondBtn;
@end

@implementation SeatNumberBottomView

-(void)setStatus:(SeatNumberStatus)orderStatus{
    _status=orderStatus;
    NSArray * titleArr=[NSArray array];
    if (orderStatus==WAITSHOPSURE) {
        if (self.is_seat)  titleArr=@[NSLocalizedString(@"取消订座", nil)];//@"点我催单"
        else titleArr=@[NSLocalizedString(@"取消排队", nil)];
    }
    
    if (orderStatus==SUCCESS) {
        if (self.is_seat)  titleArr=@[@""];//@"点我催单"
        else titleArr=@[@""];
    }
    
    if (orderStatus==CANCEL || orderStatus==COMPLETE) {
        if (self.is_seat) titleArr=@[NSLocalizedString(@"删除订单", nil)];
        else titleArr=@[NSLocalizedString(@"删除订单", nil)];
    }
    
    [self reloadBtn:titleArr];
}

-(instancetype)init{
    if (self=[super init]) {
        [self configUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    backView.backgroundColor=[UIColor whiteColor];
    
    UIView *lineView2=[[UIView alloc] initWithFrame:CGRectMake(10, self.height-0.5, WIDTH-20, 0.5)];
    lineView2.backgroundColor=LINE_COLOR;
    [backView addSubview:lineView2];
    
    [self addSubview:backView];
    
    CGFloat margin=10;
    CGFloat btnW=(WIDTH-3*10)/2.0;
    CGFloat btnH=40;
    
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton new];
        [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        btn.layer.cornerRadius=4;
        btn.clipsToBounds=YES;
        btn.layer.borderColor=HEX(@"ededed", 1.0).CGColor;
        btn.layer.borderWidth=1;
        btn.backgroundColor=HEX(@"fafafa", 1.0);
        btn.titleLabel.font=[UIFont systemFontOfSize:18];
        [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=margin+(margin+btnW)*i;
            make.top.offset=5;
            make.width.offset=btnW;
            make.height.offset=btnH;
        }];
        
        if (i==0)   self.firstBtn=btn;
        if (i==1)   self.secondBtn=btn;
    }
    
}


-(void)onClick:(UIButton *)btn{
    
    if ([btn.currentTitle containsString:NSLocalizedString(@"取消", nil)]) {
        if (self.cancleOrder)  self.cancleOrder();
        return;
    }
   
    if ([btn.currentTitle containsString:NSLocalizedString(@"删除", nil)]) {
        if (self.deleteOrder)  self.deleteOrder();
        return;
    }
    if ([btn.currentTitle isEqualToString:NSLocalizedString(@"点我催单", nil)]) {
        if (self.cuiOrder)  self.cuiOrder();
        return;
    }
    
}

-(void)reloadBtn:(NSArray *)titleArr{

   [self.firstBtn setTitle:titleArr[0] forState:UIControlStateNormal];
    if(titleArr.count==1){
        self.secondBtn.hidden=YES;
        [self.secondBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset=WIDTH;
            make.width.offset=0;
            make.height.offset=0;
        }];
        [self.firstBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.right.offset=-10;
        }];
        
    }else{
        self.secondBtn.hidden=NO;
        [self.secondBtn setTitle:titleArr[1] forState:UIControlStateNormal];
        
        CGFloat btnW=(WIDTH-3*10)/2.0;
        CGFloat btnH=40;
        [self.secondBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset=20+btnW;
            make.top.offset=5;
            make.width.offset=btnW;
            make.height.offset=btnH;
        }];
        
        [self.firstBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.top.offset=5;
            make.right.equalTo(self.secondBtn.mas_left).offset=-10;
            make.height.offset=btnH;
        }];
        
    }
    
}

@end
