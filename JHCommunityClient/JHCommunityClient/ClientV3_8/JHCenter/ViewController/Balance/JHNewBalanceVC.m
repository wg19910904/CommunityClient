//
//  JHNewBalanceVC.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/5/17.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHNewBalanceVC.h"
#import "JHNewRechargeVC.h"
 
#import "JHTempWebViewVC.h"

@interface JHNewBalanceVC (){
    UIImageView *topImg;
    UILabel *desL;
    UILabel *moneyL;
    UIButton *rechargeBtn;
    UIButton *tixianBtn;
    UIButton *mingxiBtn;
    NSDictionary *dic;
}

@end

@implementation JHNewBalanceVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"余额";
    [self getData];

    [self creatUI];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void)getData{
    
    [HttpTool postWithAPI:@"client/v3/member/money/index" withParams:@{} success:^(id json) {
        if ([json[@"error"] isEqualToString:@"0"]) {
            dic = json[@"data"];
           
            moneyL.text = [NSString stringWithFormat:@"¥%@",json[@"data"][@"money"]];
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",moneyL.text]];
            NSRange range1=[[hintString string]rangeOfString:@"¥"];
            [hintString addAttribute:NSFontAttributeName value:FONT(20) range:range1];
            moneyL.attributedText = hintString;
            
        }else{
            [self showMsg:json[@"message"]];
        }
        
    } failure:^(NSError *error) {
        [self showNoNetOrBusy:YES];
    }];
    
    
}
-(void)creatUI{
    
    topImg = [[UIImageView alloc]init];
    [self.view addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.offset = 100*PROPORTION;
        make.width.offset = 95*PROPORTION;
        make.height.offset = 105*PROPORTION;
    }];
    topImg.image = IMAGE(@"big_money_img");
    
    desL= [[UILabel alloc]init];
    [self.view addSubview:desL];
    [desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(topImg.mas_bottom).offset = 10;
        make.width.offset = 115;
        make.height.offset = 20;
    }];
    desL.textColor = TEXT_COLOR;
    desL.font = FONT(15);
    desL.textAlignment = NSTextAlignmentCenter;
    desL.text = @"账户余额";
    
    moneyL = [[UILabel alloc]init];
    [self.view addSubview:moneyL];
    [moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(desL.mas_bottom).offset = 10;
        make.width.offset = 200;
        make.height.offset = 50;
    }];
    moneyL.textAlignment = NSTextAlignmentCenter;
    moneyL.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:20];
    moneyL.font = FONT(40);
    moneyL.textColor = HEX(@"151515", 1);
    moneyL.text = @"¥00";
    
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",moneyL.text]];
    NSRange range1=[[hintString string]rangeOfString:@"¥"];
    [hintString addAttribute:NSFontAttributeName value:FONT(20) range:range1];
    moneyL.attributedText = hintString;
    
    
    
    rechargeBtn = [[UIButton alloc]init];
    [self.view addSubview:rechargeBtn];
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyL.mas_bottom).offset = 45;
        make.left.offset = 12;
        make.right.offset = -12;
        make.height.offset = 44;
    }];
    rechargeBtn.layer.cornerRadius = 2;
    rechargeBtn.layer.masksToBounds = YES;
    rechargeBtn.backgroundColor = THEME_COLOR;
    [rechargeBtn setTitle:@"充值" forState:0];
    [rechargeBtn setTitleColor:THEME_COLOR_WHITE_Alpha(1) forState:0];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    tixianBtn = [[UIButton alloc]init];
    [self.view addSubview:tixianBtn];
    [tixianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rechargeBtn.mas_bottom).offset = 19;
        make.left.offset = 12;
        make.right.offset = -12;
        make.height.offset = 44;
    }];
    tixianBtn.layer.cornerRadius = 2;
    tixianBtn.layer.masksToBounds = YES;
    tixianBtn.layer.borderWidth = 1.f;
    tixianBtn.layer.borderColor = HEX(@"e5e5e5", 1).CGColor;
    tixianBtn.backgroundColor = THEME_COLOR_WHITE_Alpha(1);
    [tixianBtn setTitleColor:TEXT_COLOR forState:0];
    [tixianBtn setTitle:@"提现" forState:0];
    [tixianBtn addTarget:self action:@selector(tixianBtnClick) forControlEvents:UIControlEventTouchUpInside];
    tixianBtn.hidden = YES;
    
    mingxiBtn = [[UIButton alloc]init];
    [self.view addSubview:mingxiBtn];
    [mingxiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -29;
        make.centerX.offset = 0;
        make.width.offset = 200;
        make.height.offset = 40;
    }];
    [mingxiBtn setTitle:@"查看余额明细>>" forState:0];
    [mingxiBtn setTitleColor:TEXT_COLOR forState:0];
    [mingxiBtn addTarget:self action:@selector(mingxiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    mingxiBtn.titleLabel.font = FONT(14);
 
    
    
}
#pragma mark - 充值点击
-(void)rechargeBtnClick{
    JHNewRechargeVC *vc = [[JHNewRechargeVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 提现点击
-(void)tixianBtnClick{
    
}
#pragma mark - 点击明细
-(void)mingxiBtnClick{
    JHTempWebViewVC *vc = [[JHTempWebViewVC alloc]init];
    vc.url = dic[@"url"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//}
@end
