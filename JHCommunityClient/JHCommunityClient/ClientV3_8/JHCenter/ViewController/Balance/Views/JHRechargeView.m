//
//  JHRechargeView.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHRechargeView.h"

@interface JHRechargeView()
@property(nonatomic,strong)UILabel *topL;
@property(nonatomic,strong)UILabel *bottomL;

@end

@implementation JHRechargeView



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self addUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:@"changeView" object:nil];
        
    }
    return self;
}


-(void)addUI{
    
    self.layer.borderColor = HEX(@"cccccc", 1).CGColor;
    self.layer.borderWidth = 1;
    
    
    _topL = [[UILabel alloc]initWithFrame:FRAME(0, 0, self.frame.size.width, self.frame.size.height/2)];
    [self addSubview:_topL];
    _topL.font = FONT(18);
    _topL.textAlignment = NSTextAlignmentCenter;
    _topL.textColor = HEX(@"666666", 1);
    
    _bottomL = [[UILabel alloc]initWithFrame:FRAME(0,self.frame.size.height/2, self.frame.size.width, self.bounds.size.height/2)];
    [self addSubview:_bottomL];
    _bottomL.font =FONT(12);

     _bottomL.textColor = HEX(@"666666", 1);
    _bottomL.textAlignment = NSTextAlignmentCenter;
    
    
    
}
-(void)changeView:(NSNotification *)noti{
    NSDictionary  *dic = [noti userInfo];
    NSString * tag = [NSString stringWithFormat:@"%@",dic[@"tag"]];
    
    if ([tag isEqualToString:[NSString stringWithFormat:@"%ld",self.tag]]) {
           self.layer.borderColor = THEME_COLOR.CGColor;
        _topL.textColor =THEME_COLOR;
        _bottomL.textColor = THEME_COLOR;
    }else{
         _topL.textColor = HEX(@"666666", 1);
        self.layer.borderColor = HEX(@"cccccc", 1).CGColor;
        _bottomL.textColor = HEX(@"666666", 1);
    }
    
    
}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    _topL.text = [NSString stringWithFormat:@"¥%@",dic[@"chong"]];
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",_topL.text]];
    NSRange range1=[[hintString string]rangeOfString:@"¥"];
    [hintString addAttribute:NSFontAttributeName value:FONT(12) range:range1];
    _topL.attributedText = hintString;
    
    _bottomL.text =[NSString stringWithFormat:@"冲%@送%@元",dic[@"chong"],dic[@"song"]];
    
    
}




@end
